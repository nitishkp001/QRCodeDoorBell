from sqlalchemy.orm import Session
from app.core.config import settings
from app.models.types import UUIDString
from app.models.enums import UserRole
from app.models.device_token import DeviceToken
from app.models.qr_code import QRCode
from app.models.user import User
from app.models.video_call import VideoCall
from app.core.security import get_password_hash

def init_db(db: Session) -> None:
    """Initialize the database with required initial data"""
    # Create admin user if it doesn't exist
    admin = db.query(User).filter(User.email == "admin@example.com").first()
    if not admin:
        admin_user = User(
            email="admin@example.com",
            password_hash=get_password_hash("admin_password"),  # Change this in production
            role=UserRole.ADMIN,
            first_name="Admin",
            last_name="User"
        )
        db.add(admin_user)
        db.commit()
        db.refresh(admin_user)
