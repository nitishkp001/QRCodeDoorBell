from typing import Optional
from dataclasses import dataclass
from dataclasses_json import dataclass_json

@dataclass_json
@dataclass
class Token:
    access_token: str
    token_type: str

@dataclass_json
@dataclass
class TokenPayload:
    sub: Optional[str] = None
    exp: Optional[int] = None  # Add expiration time field
