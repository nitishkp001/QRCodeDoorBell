import os
from typing import Dict, List
from dotenv import load_dotenv
from pydantic import AnyHttpUrl, BaseSettings

# Load environment variables from .env file
load_dotenv()

class Settings(BaseSettings):
    # API Configuration
    PROJECT_NAME: str = "QR Doorbell App"
    API_V1_PREFIX: str = "/api/v1"
    
    # Server Configuration
    SERVER_HOST: str = os.getenv("SERVER_HOST", "localhost")
    SERVER_PORT: int = int(os.getenv("SERVER_PORT", "8000"))
    
    @property
    def WEBSOCKET_URL(self) -> str:
        return f"ws://{self.SERVER_HOST}:{self.SERVER_PORT}{self.API_V1_PREFIX}"
    
    # JWT Configuration
    JWT_SECRET_KEY: str = os.getenv("JWT_SECRET_KEY")
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))

    # Database Configuration
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./qr_doorbell.db")

    # CORS Configuration
    BACKEND_CORS_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://localhost:8000",
        "http://localhost:51194",  # Flutter web port
        "ws://localhost:*",        # WebSocket connections
        "wss://localhost:*",       # Secure WebSocket connections
        "http://localhost:*",      # Any localhost HTTP connection
    ]

    # Environment
    ENVIRONMENT: str = "development"

    # Firebase Configuration
    FIREBASE_PROJECT_ID: str = os.getenv("FIREBASE_PROJECT_ID", "")
    FIREBASE_SERVER_KEY: str = os.getenv("FIREBASE_SERVER_KEY", "")

settings = Settings()
