from datetime import timedelta
from typing import Any
from fastapi import APIRouter, Depends, HTTPException, status, Request, Form
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from app.core import security
from app.core.config import settings
from app.api import deps
from app.schemas.token import Token
from app.crud import crud_user
from app.schemas.user import UserCreate
import logging

logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/login", response_model=Token)
async def login(
    email: str = Form(..., alias="username"),
    password: str = Form(...),
    db: Session = Depends(deps.get_db),
) -> Any:
    """OAuth2 compatible token login, get an access token for future requests"""
    logger.info(f"Login attempt for email: {email}")
    
    try:
        user = crud_user.authenticate(db, email=email, password=password)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password",
            )
        
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        return {
            "access_token": security.create_access_token(
                user.id, expires_delta=access_token_expires
            ),
            "token_type": "bearer",
        }
    except Exception as e:
        logger.error(f"Login failed: {str(e)}")
        raise

@router.post("/register", response_model=Token)
async def register(
    email: str = Form(...),
    password: str = Form(...),
    first_name: str = Form(None),
    last_name: str = Form(None),
    db: Session = Depends(deps.get_db),
) -> Any:
    """Register a new user"""
    try:
        # Validate email format
        if not '@' in email:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid email format",
            )
        
        # Validate password length
        if len(password) < 6:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Password must be at least 6 characters long",
            )

        logger.info(f"Received registration request for email: {email}")
        
        # Check if user exists
        user = crud_user.get_by_email(db, email=email)
        if user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered",
            )
        
        # Create user object
        user_in = UserCreate(
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name
        )
        
        # Create user in database
        try:
            user = crud_user.create(db, obj_in=user_in)
        except Exception as e:
            logger.error(f"Database error during user creation: {str(e)}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Error creating user in database",
            )
        
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        return {
            "access_token": security.create_access_token(
                user.id, expires_delta=access_token_expires
            ),
            "token_type": "bearer",
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Unexpected error during registration: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred",
        )
