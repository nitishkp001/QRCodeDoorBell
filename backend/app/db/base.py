# Import all the models, so that Base has them before being
# imported by Alembic
from app.db.base_class import Base
from app.models.types import UUIDString
from app.models.enums import UserRole
from app.models.device_token import DeviceToken
from app.models.qr_code import QRCode
from app.models.user import User
from app.models.video_call import VideoCall
