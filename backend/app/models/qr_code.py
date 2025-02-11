import uuid
from sqlalchemy import Column, String, Boolean, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from app.db.base_class import Base
from app.models.types import UUIDString

class QRCode(Base):
    __tablename__ = "qr_codes"

    id = Column(UUIDString, primary_key=True, default=lambda: str(uuid.uuid4()))
    owner_id = Column(UUIDString, ForeignKey("users.id"), nullable=False)
    name = Column(String, nullable=False)
    description = Column(String)
    is_active = Column(Boolean, default=True)
    expiry_date = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)
    
    # Relationships
    owner = relationship("User", back_populates="qr_codes")
