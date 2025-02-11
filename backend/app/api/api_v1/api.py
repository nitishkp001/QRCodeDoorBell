from fastapi import APIRouter
from app.api.api_v1.endpoints import auth, users, qr_codes, video_calls, device_tokens, notifications, web_call

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(qr_codes.router, prefix="/qr-codes", tags=["qr-codes"])
api_router.include_router(video_calls.router, prefix="/video-calls", tags=["video-calls"])
api_router.include_router(device_tokens.router, prefix="/device-tokens", tags=["device-tokens"])
api_router.include_router(notifications.router, prefix="/notifications", tags=["notifications"])
api_router.include_router(web_call.router, prefix="/web-call", tags=["web-call"])
