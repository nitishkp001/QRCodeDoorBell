from typing import List, Optional
from datetime import datetime
from sqlalchemy.orm import Session
from app.models.device_token import DeviceToken
from app.schemas.device_token import DeviceTokenCreate

def get(db: Session, id: str) -> Optional[DeviceToken]:
    return db.query(DeviceToken).filter(DeviceToken.id == id).first()

def get_by_token(db: Session, token: str) -> Optional[DeviceToken]:
    return db.query(DeviceToken).filter(DeviceToken.token == token).first()

def get_multi_by_user(
    db: Session, *, user_id: str, skip: int = 0, limit: int = 100
) -> List[DeviceToken]:
    return (
        db.query(DeviceToken)
        .filter(DeviceToken.user_id == user_id)
        .offset(skip)
        .limit(limit)
        .all()
    )

def create(db: Session, *, obj_in: DeviceTokenCreate, user_id: str) -> DeviceToken:
    db_obj = DeviceToken(
        user_id=user_id,
        token=obj_in.token,
        device_type=obj_in.device_type
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def update_last_used(db: Session, *, db_obj: DeviceToken) -> DeviceToken:
    db_obj.last_used_at = datetime.utcnow()
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def delete(db: Session, *, id: str) -> DeviceToken:
    obj = db.query(DeviceToken).get(id)
    db.delete(obj)
    db.commit()
    return obj
