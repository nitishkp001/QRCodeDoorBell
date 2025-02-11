from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api import deps
from app.crud import crud_device_token
from app.schemas.device_token import DeviceToken, DeviceTokenCreate
from app.models.user import User

router = APIRouter()

@router.post("/", response_model=DeviceToken)
def create_device_token(
    *,
    db: Session = Depends(deps.get_db),
    device_token_in: DeviceTokenCreate,
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Register a new device token for push notifications.
    """
    # Check if token already exists
    existing_token = crud_device_token.get_by_token(db=db, token=device_token_in.token)
    if existing_token:
        if existing_token.user_id != current_user.id:
            # If token exists but belongs to another user, delete it
            crud_device_token.delete(db=db, id=str(existing_token.id))
        else:
            # If token exists for current user, update last used
            return crud_device_token.update_last_used(db=db, db_obj=existing_token)
    
    # Create new token
    device_token = crud_device_token.create(
        db=db, obj_in=device_token_in, user_id=str(current_user.id)
    )
    return device_token

@router.get("/", response_model=List[DeviceToken])
def read_device_tokens(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Retrieve device tokens.
    """
    device_tokens = crud_device_token.get_multi_by_user(
        db=db, user_id=str(current_user.id), skip=skip, limit=limit
    )
    return device_tokens

@router.delete("/{token_id}", response_model=DeviceToken)
def delete_device_token(
    *,
    db: Session = Depends(deps.get_db),
    token_id: str,
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Delete device token.
    """
    device_token = crud_device_token.get(db=db, id=token_id)
    if not device_token:
        raise HTTPException(status_code=404, detail="Device token not found")
    if device_token.user_id != current_user.id:
        raise HTTPException(status_code=400, detail="Not enough permissions")
    device_token = crud_device_token.delete(db=db, id=token_id)
    return device_token
