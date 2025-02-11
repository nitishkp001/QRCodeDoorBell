from typing import List
from fastapi import APIRouter, Depends, HTTPException, WebSocket, WebSocketDisconnect, status
from sqlalchemy.orm import Session
from app.api import deps
from app.crud import crud_video_call, crud_qr_code, crud_device_token
from app.schemas.video_call import VideoCall, VideoCallCreate, VideoCallUpdate
from app.models.user import User
from app.models.video_call import CallStatus
from app.core.signaling import SignalingManager
from app.core.firebase import firebase_manager
from uuid import UUID

# Initialize signaling manager
signaling_manager = SignalingManager()

# Create router without dependencies
router = APIRouter()

@router.websocket("/ws/{call_id}")
async def websocket_endpoint(
    websocket: WebSocket,
    call_id: str,
    db: Session = Depends(deps.get_db),
):
    """
    WebSocket endpoint for authenticated video call signaling
    """
    await websocket.accept()
    try:
        # Get token from headers
        headers = dict(websocket.headers)
        auth_header = headers.get("authorization", "")
        token = auth_header.replace("Bearer ", "") if auth_header.startswith("Bearer ") else None
        
        if not token:
            print("No token provided")
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return
            
        # Verify token and get user
        current_user = await deps.get_current_user_ws(db, token)
        if not current_user:
            print("Invalid token")
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return

        # Get the video call
        video_call = crud_video_call.get(db=db, id=call_id)
        if not video_call:
            print("Video call not found")
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return
        
        # Verify user is part of the call
        if current_user.id not in [video_call.visitor_id, video_call.owner_id]:
            print("User not part of call")
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return
        
        # Add to signaling manager
        await signaling_manager.connect(websocket, call_id, str(current_user.id))
        print(f"Connected user {current_user.id} to call {call_id}")
        
        try:
            while True:
                data = await websocket.receive_json()
                # Handle different types of messages
                if data["type"] == "offer":
                    await signaling_manager.broadcast_offer(call_id, current_user.id, data["sdp"])
                elif data["type"] == "answer":
                    await signaling_manager.broadcast_answer(call_id, current_user.id, data["sdp"])
                elif data["type"] == "ice-candidate":
                    await signaling_manager.broadcast_ice_candidate(call_id, current_user.id, data["candidate"])
                elif data["type"] == "end-call":
                    crud_video_call.mark_as_completed(db=db, db_obj=video_call)
                    await signaling_manager.broadcast_call_ended(call_id, current_user.id)
        except WebSocketDisconnect:
            signaling_manager.disconnect(call_id, str(current_user.id))
            if video_call.status == CallStatus.INITIATED:
                crud_video_call.mark_as_missed(db=db, db_obj=video_call)
    except Exception as e:
        print(f"Error in websocket: {str(e)}")
        await websocket.close(code=status.WS_1011_INTERNAL_ERROR)

@router.websocket("/guest-ws/{qr_code_id}")
async def guest_websocket_endpoint(
    websocket: WebSocket,
    qr_code_id: str,
    db: Session = Depends(deps.get_db),
):
    """
    WebSocket endpoint for guest video call signaling
    """
    await websocket.accept()
    try:
        # Check if QR code exists and is active
        qr_code = crud_qr_code.get(db=db, id=qr_code_id)
        if not qr_code or not qr_code.is_active:
            print("QR code not found or not active")
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return

        # Create a temporary video call for the guest
        video_call_in = VideoCallCreate(qr_code_id=UUID(qr_code_id))  # Convert string to UUID
        video_call = crud_video_call.create(
            db=db,
            obj_in=video_call_in,
            visitor_id=None,  # Guest call
            owner_id=str(qr_code.owner_id)
        )
        print(f"Created guest video call {video_call.id} for QR code {qr_code_id}")
        
        # Add to signaling manager with a temporary guest ID
        guest_id = f"guest_{video_call.id}"
        await signaling_manager.connect(websocket, str(video_call.id), guest_id)
        print(f"Connected guest {guest_id} to call {video_call.id}")
        
        try:
            while True:
                data = await websocket.receive_json()
                # Handle different types of messages
                if data["type"] == "offer":
                    await signaling_manager.broadcast_offer(str(video_call.id), guest_id, data["sdp"])
                elif data["type"] == "answer":
                    await signaling_manager.broadcast_answer(str(video_call.id), guest_id, data["sdp"])
                elif data["type"] == "ice-candidate":
                    await signaling_manager.broadcast_ice_candidate(str(video_call.id), guest_id, data["candidate"])
                elif data["type"] == "end-call":
                    crud_video_call.mark_as_completed(db=db, db_obj=video_call)
                    await signaling_manager.broadcast_call_ended(str(video_call.id), guest_id)
        except WebSocketDisconnect:
            signaling_manager.disconnect(str(video_call.id), guest_id)
            if video_call.status == CallStatus.INITIATED:
                crud_video_call.mark_as_missed(db=db, db_obj=video_call)
    except Exception as e:
        print(f"Error in guest websocket: {str(e)}")
        await websocket.close(code=status.WS_1011_INTERNAL_ERROR)

@router.post("/", response_model=VideoCall)
async def create_video_call(
    db: Session = Depends(deps.get_db),
    video_call_in: VideoCallCreate = None,
    token: str = None
):
    """
    Create new video call.
    """
    # Verify token and get user
    current_user = await deps.get_current_user_ws(db, token)
    if not current_user:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    # Check if QR code exists and is active
    qr_code = crud_qr_code.get(db=db, id=str(video_call_in.qr_code_id))
    if not qr_code:
        raise HTTPException(status_code=404, detail="QR code not found")
    if not qr_code.is_active:
        raise HTTPException(status_code=400, detail="QR code is not active")

    # Create the video call
    video_call = crud_video_call.create(
        db=db,
        obj_in=video_call_in,
        visitor_id=str(current_user.id),
        owner_id=str(qr_code.owner_id)
    )

    # Send notification to owner's device
    owner_tokens = crud_device_token.get_user_tokens(db=db, user_id=str(qr_code.owner_id))
    if owner_tokens:
        for token in owner_tokens:
            firebase_manager.send_notification(
                token=token.token,
                title="New Video Call",
                body=f"Someone is at your door",
                data={
                    "call_id": str(video_call.id),
                    "type": "video_call"
                }
            )

    return video_call

@router.get("/", response_model=List[VideoCall])
async def read_video_calls(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    token: str = None
):
    """
    Retrieve video calls.
    """
    # Verify token and get user
    current_user = await deps.get_current_user_ws(db, token)
    if not current_user:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    if current_user.role == "VISITOR":
        video_calls = crud_video_call.get_multi_by_visitor(
            db=db, visitor_id=str(current_user.id), skip=skip, limit=limit
        )
    else:
        video_calls = crud_video_call.get_multi_by_owner(
            db=db, owner_id=str(current_user.id), skip=skip, limit=limit
        )
    return video_calls

@router.get("/{call_id}", response_model=VideoCall)
async def read_video_call(
    call_id: str,
    db: Session = Depends(deps.get_db),
    token: str = None
):
    """
    Get video call by ID.
    """
    # Verify token and get user
    current_user = await deps.get_current_user_ws(db, token)
    if not current_user:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    video_call = crud_video_call.get(db=db, id=call_id)
    if not video_call:
        raise HTTPException(status_code=404, detail="Video call not found")
    if current_user.id not in [video_call.visitor_id, video_call.owner_id]:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    return video_call

@router.put("/{call_id}", response_model=VideoCall)
async def update_video_call(
    call_id: str,
    video_call_in: VideoCallUpdate,
    db: Session = Depends(deps.get_db),
    token: str = None
):
    """
    Update video call status.
    """
    # Verify token and get user
    current_user = await deps.get_current_user_ws(db, token)
    if not current_user:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    video_call = crud_video_call.get(db=db, id=call_id)
    if not video_call:
        raise HTTPException(status_code=404, detail="Video call not found")
    if current_user.id not in [video_call.visitor_id, video_call.owner_id]:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    video_call = crud_video_call.update(
        db=db,
        db_obj=video_call,
        obj_in=video_call_in
    )
    return video_call
