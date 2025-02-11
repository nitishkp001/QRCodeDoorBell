from typing import Optional
from datetime import datetime
from pydantic import BaseModel

class QRCodeBase(BaseModel):
    name: str
    description: Optional[str] = None
    is_active: bool = True
    expiry_date: Optional[datetime] = None

class QRCodeCreate(QRCodeBase):
    pass

class QRCodeUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None
    expiry_date: Optional[datetime] = None

class QRCode(QRCodeBase):
    id: str
    owner_id: str
    created_at: datetime
    description: Optional[str] = None
    is_active: bool = True
    expiry_date: Optional[datetime] = None

    class Config:
        from_attributes = True  # Allows conversion from SQLAlchemy model
