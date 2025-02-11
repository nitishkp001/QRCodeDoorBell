from typing import List, Optional
from datetime import datetime
from sqlalchemy.orm import Session
from app.models.video_call import VideoCall, CallStatus
from app.schemas.video_call import VideoCallCreate, VideoCallUpdate

def get(db: Session, id: str) -> Optional[VideoCall]:
    return db.query(VideoCall).filter(VideoCall.id == id).first()

def get_active_call_by_qr_code(db: Session, qr_code_id: str) -> Optional[VideoCall]:
    return (
        db.query(VideoCall)
        .filter(
            VideoCall.qr_code_id == qr_code_id,
            VideoCall.status.in_([CallStatus.INITIATED, CallStatus.CONNECTED])
        )
        .first()
    )

def get_multi_by_owner(
    db: Session, *, owner_id: str, skip: int = 0, limit: int = 100
) -> List[VideoCall]:
    return (
        db.query(VideoCall)
        .filter(VideoCall.owner_id == owner_id)
        .order_by(VideoCall.start_time.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )

def get_multi_by_visitor(
    db: Session, *, visitor_id: str, skip: int = 0, limit: int = 100
) -> List[VideoCall]:
    return (
        db.query(VideoCall)
        .filter(VideoCall.visitor_id == visitor_id)
        .order_by(VideoCall.start_time.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )

def create(
    db: Session, *, obj_in: VideoCallCreate, visitor_id: str, owner_id: str
) -> VideoCall:
    db_obj = VideoCall(
        qr_code_id=obj_in.qr_code_id,
        visitor_id=visitor_id,
        owner_id=owner_id,
        session_id=obj_in.session_id,
        status=CallStatus.INITIATED
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def update(
    db: Session, *, db_obj: VideoCall, obj_in: VideoCallUpdate
) -> VideoCall:
    if obj_in.status is not None:
        db_obj.status = obj_in.status
    if obj_in.session_id is not None:
        db_obj.session_id = obj_in.session_id
    if obj_in.end_time is not None:
        db_obj.end_time = obj_in.end_time
    
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def mark_as_missed(db: Session, *, db_obj: VideoCall) -> VideoCall:
    db_obj.status = CallStatus.MISSED
    db_obj.end_time = datetime.utcnow()
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def mark_as_completed(db: Session, *, db_obj: VideoCall) -> VideoCall:
    db_obj.status = CallStatus.COMPLETED
    db_obj.end_time = datetime.utcnow()
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj
