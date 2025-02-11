import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.db.base_class import Base
from app.models.types import UUIDString

class DeviceToken(Base):
    __tablename__ = "device_tokens"

    id = Column(UUIDString, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(UUIDString, ForeignKey("users.id"), nullable=False)
    token = Column(String, nullable=False, unique=True)
    device_type = Column(String, nullable=False)  # ios, android, web
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)
    last_used_at = Column(DateTime(timezone=True), default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="device_tokens")

    def __repr__(self):
        return f"<DeviceToken {self.id}>"
