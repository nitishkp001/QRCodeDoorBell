from dataclasses import dataclass, field
from typing import Optional
from uuid import UUID
from dataclasses_json import dataclass_json
from app.models.enums import UserRole

@dataclass_json
@dataclass
class UserBase:
    # All fields are optional in base
    email: Optional[str] = field(default=None)
    first_name: Optional[str] = field(default=None)
    last_name: Optional[str] = field(default=None)
    phone_number: Optional[str] = field(default=None)
    role: UserRole = field(default=UserRole.VISITOR)

@dataclass_json
@dataclass
class UserCreate:
    # Required fields first
    email: str
    password: str
    # Optional fields with defaults
    first_name: Optional[str] = field(default=None)
    last_name: Optional[str] = field(default=None)
    phone_number: Optional[str] = field(default=None)
    role: UserRole = field(default=UserRole.VISITOR)

@dataclass_json
@dataclass
class UserUpdate:
    # All fields are optional in update
    email: Optional[str] = field(default=None)
    password: Optional[str] = field(default=None)
    first_name: Optional[str] = field(default=None)
    last_name: Optional[str] = field(default=None)
    phone_number: Optional[str] = field(default=None)
    role: Optional[UserRole] = field(default=None)

@dataclass_json
@dataclass
class UserInDBBase:
    # Required fields first
    id: UUID
    email: str
    # Optional fields with defaults
    first_name: Optional[str] = field(default=None)
    last_name: Optional[str] = field(default=None)
    phone_number: Optional[str] = field(default=None)
    role: UserRole = field(default=UserRole.VISITOR)
    is_active: bool = field(default=True)

@dataclass_json
@dataclass
class User(UserInDBBase):
    pass

@dataclass_json
@dataclass
class UserInDB:
    # Required fields first
    id: UUID
    email: str
    password_hash: str
    # Optional fields with defaults
    first_name: Optional[str] = field(default=None)
    last_name: Optional[str] = field(default=None)
    phone_number: Optional[str] = field(default=None)
    role: UserRole = field(default=UserRole.VISITOR)
    is_active: bool = field(default=True)
