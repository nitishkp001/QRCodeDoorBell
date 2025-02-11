from dataclasses import dataclass, field
from typing import Optional
from datetime import datetime
from uuid import UUID
from dataclasses_json import dataclass_json

@dataclass_json
@dataclass
class DeviceTokenCreate:
    # Required fields first
    token: str
    device_type: str

@dataclass_json
@dataclass
class DeviceToken:
    # Required fields first
    id: UUID
    user_id: UUID
    token: str
    device_type: str
    created_at: datetime
    last_used_at: datetime
