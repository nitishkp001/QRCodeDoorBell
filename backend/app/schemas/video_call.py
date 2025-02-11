from dataclasses import dataclass, field
from typing import Optional
from datetime import datetime
from uuid import UUID
from dataclasses_json import dataclass_json
from app.models.video_call import CallStatus

@dataclass_json
@dataclass
class VideoCallCreate:
    # Required fields first
    qr_code_id: UUID
    # Optional fields with defaults
    session_id: Optional[str] = field(default=None)

@dataclass_json
@dataclass
class VideoCallUpdate:
    # All fields optional
    status: Optional[CallStatus] = field(default=None)
    session_id: Optional[str] = field(default=None)
    end_time: Optional[datetime] = field(default=None)

@dataclass_json
@dataclass
class VideoCall:
    # Required fields first
    id: UUID
    visitor_id: UUID
    owner_id: UUID
    qr_code_id: UUID
    status: CallStatus
    start_time: datetime
    # Optional fields with defaults
    session_id: Optional[str] = field(default=None)
    end_time: Optional[datetime] = field(default=None)
