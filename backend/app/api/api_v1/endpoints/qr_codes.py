from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.api import deps
from app.crud import crud_qr_code
from app.schemas.qr_code import QRCode, QRCodeCreate, QRCodeUpdate
from app.models.user import User

router = APIRouter()

@router.get("/", response_model=List[QRCode])
def read_qr_codes(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Retrieve QR codes for the current user.
    """
    qr_codes = crud_qr_code.get_multi_by_owner(
        db=db, owner_id=str(current_user.id), skip=skip, limit=limit
    )
    return [qr_code.to_dict() for qr_code in qr_codes]

@router.post("/", response_model=QRCode)
def create_qr_code(
    *,
    db: Session = Depends(deps.get_db),
    qr_code_in: QRCodeCreate,
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Create new QR code.
    """
    qr_code = crud_qr_code.create(db=db, obj_in=qr_code_in, owner_id=str(current_user.id))
    return qr_code.to_dict()

@router.put("/{qr_code_id}", response_model=QRCode)
def update_qr_code(
    *,
    db: Session = Depends(deps.get_db),
    qr_code_id: str,
    qr_code_in: QRCodeUpdate,
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Update QR code.
    """
    qr_code = crud_qr_code.get(db=db, id=qr_code_id)
    if not qr_code:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="QR code not found"
        )
    if qr_code.owner_id != str(current_user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    qr_code = crud_qr_code.update(db=db, db_obj=qr_code, obj_in=qr_code_in)
    return qr_code.to_dict()

@router.get("/{qr_code_id}", response_model=QRCode)
def read_qr_code(
    *,
    db: Session = Depends(deps.get_db),
    qr_code_id: str,
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Get QR code by ID.
    """
    qr_code = crud_qr_code.get(db=db, id=qr_code_id)
    if not qr_code:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="QR code not found"
        )
    if qr_code.owner_id != str(current_user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    return qr_code.to_dict()

@router.delete("/{qr_code_id}", response_model=QRCode)
def delete_qr_code(
    *,
    db: Session = Depends(deps.get_db),
    qr_code_id: str,
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Delete QR code.
    """
    qr_code = crud_qr_code.get(db=db, id=qr_code_id)
    if not qr_code:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="QR code not found"
        )
    if qr_code.owner_id != str(current_user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    qr_code = crud_qr_code.delete(db=db, id=qr_code_id)
    return qr_code.to_dict()
