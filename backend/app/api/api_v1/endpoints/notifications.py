from fastapi import APIRouter, Depends, WebSocket, WebSocketDisconnect, Query
from sqlalchemy.orm import Session
from app.api import deps
from app.models.user import User
from typing import Dict
from datetime import datetime
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

# Store active connections
connections: Dict[str, WebSocket] = {}

@router.websocket("/ws")
async def websocket_endpoint(
    websocket: WebSocket,
    token: str = Query(...),
    db: Session = Depends(deps.get_db),
):
    """
    WebSocket endpoint for real-time notifications
    """
    try:
        logger.info(f"WebSocket connection attempt with token length: {len(token)}")
        
        # Verify token and get user
        user = await deps.get_current_user_ws(db, token)
        if not user:
            logger.warning("WebSocket connection rejected: Invalid token")
            await websocket.close(code=1008)  # Policy violation
            return

        # Accept the connection
        await websocket.accept()
        user_id = str(user.id)
        connections[user_id] = websocket
        logger.info(f"WebSocket connection accepted for user: {user_id}")

        try:
            while True:
                # Keep the connection alive and handle incoming messages
                data = await websocket.receive_text()
                logger.debug(f"Received WebSocket message from user {user_id}: {data}")
        except WebSocketDisconnect:
            if user_id in connections:
                del connections[user_id]
                logger.info(f"WebSocket connection closed for user: {user_id}")
    except Exception as e:
        logger.error(f"WebSocket error: {str(e)}")
        await websocket.close(code=1008)
        return

async def notify_user(user_id: str, message: dict):
    """
    Send notification to a specific user
    """
    if user_id in connections:
        websocket = connections[user_id]
        try:
            await websocket.send_json({
                "timestamp": datetime.utcnow().isoformat(),
                **message
            })
            logger.debug(f"Notification sent to user {user_id}: {message}")
        except Exception as e:
            logger.error(f"Error sending notification to user {user_id}: {str(e)}")
            if user_id in connections:
                del connections[user_id]
