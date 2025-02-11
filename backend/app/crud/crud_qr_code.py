from typing import List, Optional
from sqlalchemy.orm import Session
from app.models.qr_code import QRCode
from app.schemas.qr_code import QRCodeCreate, QRCodeUpdate

def get(db: Session, id: str) -> Optional[QRCode]:
    return db.query(QRCode).filter(QRCode.id == id).first()

def get_multi_by_owner(
    db: Session, *, owner_id: str, skip: int = 0, limit: int = 100
) -> List[QRCode]:
    return (
        db.query(QRCode)
        .filter(QRCode.owner_id == owner_id)
        .offset(skip)
        .limit(limit)
        .all()
    )

def create(db: Session, *, obj_in: QRCodeCreate, owner_id: str) -> QRCode:
    data = {
        "name": obj_in.name,
        "description": obj_in.description,
        "is_active": obj_in.is_active,
        "expiry_date": obj_in.expiry_date,
        "owner_id": owner_id
    }
    db_obj = QRCode(**data)
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def update(
    db: Session, *, db_obj: QRCode, obj_in: QRCodeUpdate
) -> QRCode:
    update_data = {}
    if obj_in.name is not None:
        update_data["name"] = obj_in.name
    if obj_in.description is not None:
        update_data["description"] = obj_in.description
    if obj_in.is_active is not None:
        update_data["is_active"] = obj_in.is_active
    if obj_in.expiry_date is not None:
        update_data["expiry_date"] = obj_in.expiry_date
    
    for field, value in update_data.items():
        setattr(db_obj, field, value)
    
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def delete(db: Session, *, id: str) -> QRCode:
    obj = db.query(QRCode).get(id)
    db.delete(obj)
    db.commit()
    return obj
