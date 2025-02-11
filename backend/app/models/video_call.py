import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey, Enum as SQLAlchemyEnum
from sqlalchemy.orm import relationship
from app.db.base_class import Base
from app.models.types import UUIDString
from enum import Enum

class CallStatus(str, Enum):
    INITIATED = "initiated"
    CONNECTED = "connected"
    COMPLETED = "completed"
    MISSED = "missed"
    REJECTED = "rejected"

class VideoCall(Base):
    __tablename__ = "video_calls"

    id = Column(UUIDString, primary_key=True, default=lambda: str(uuid.uuid4()))
    visitor_id = Column(UUIDString, ForeignKey("users.id"), nullable=True)  # Allow null for guest calls
    owner_id = Column(UUIDString, ForeignKey("users.id"), nullable=False)
    qr_code_id = Column(UUIDString, ForeignKey("qr_codes.id"), nullable=False)
    status = Column(SQLAlchemyEnum(CallStatus, name="call_status_enum", create_constraint=True, native_enum=False), 
                   nullable=False, 
                   default=CallStatus.INITIATED)
    session_id = Column(String, nullable=True)  # WebRTC session ID
    start_time = Column(DateTime(timezone=True), default=datetime.utcnow)
    end_time = Column(DateTime(timezone=True), nullable=True)
    
    # Relationships
    visitor = relationship("User", foreign_keys=[visitor_id])
    owner = relationship("User", foreign_keys=[owner_id])
    qr_code = relationship("QRCode")
