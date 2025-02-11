from typing import List, Optional
from sqlalchemy.orm import Session
from app.core.security import get_password_hash, verify_password
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate

def get(db: Session, id: str) -> Optional[User]:
    return db.query(User).filter(User.id == id).first()

def get_by_email(db: Session, email: str) -> Optional[User]:
    return db.query(User).filter(User.email == email).first()

def get_multi(db: Session, *, skip: int = 0, limit: int = 100) -> List[User]:
    return db.query(User).offset(skip).limit(limit).all()

def create(db: Session, *, obj_in: UserCreate) -> User:
    db_obj = User(
        email=obj_in.email,
        password_hash=get_password_hash(obj_in.password),
        first_name=obj_in.first_name,
        last_name=obj_in.last_name,
        phone_number=obj_in.phone_number,
        role=obj_in.role
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def update(db: Session, *, db_obj: User, obj_in: UserUpdate) -> User:
    update_data = {
        "email": obj_in.email if obj_in.email is not None else db_obj.email,
        "first_name": obj_in.first_name if obj_in.first_name is not None else db_obj.first_name,
        "last_name": obj_in.last_name if obj_in.last_name is not None else db_obj.last_name,
        "phone_number": obj_in.phone_number if obj_in.phone_number is not None else db_obj.phone_number,
        "role": obj_in.role if obj_in.role is not None else db_obj.role
    }
    
    if obj_in.password:
        update_data["password_hash"] = get_password_hash(obj_in.password)
    
    for field, value in update_data.items():
        setattr(db_obj, field, value)
    
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

def authenticate(db: Session, *, email: str, password: str) -> Optional[User]:
    user = get_by_email(db, email=email)
    if not user:
        return None
    if not verify_password(password, user.password_hash):
        return None
    return user
