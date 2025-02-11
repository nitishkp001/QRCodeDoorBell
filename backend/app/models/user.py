import uuid
from sqlalchemy import Column, String, Boolean, Enum
from sqlalchemy.orm import relationship
from app.db.base_class import Base
from app.models.enums import UserRole
from app.models.types import UUIDString

class User(Base):
    __tablename__ = "users"

    id = Column(UUIDString, primary_key=True, default=lambda: str(uuid.uuid4()))
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    first_name = Column(String)
    last_name = Column(String)
    phone_number = Column(String)
    role = Column(Enum(UserRole), nullable=False, default=UserRole.VISITOR)
    is_active = Column(Boolean, nullable=False, default=True)

    # Relationships
    qr_codes = relationship("QRCode", back_populates="owner", cascade="all, delete-orphan")
    device_tokens = relationship("DeviceToken", back_populates="user", cascade="all, delete-orphan")
