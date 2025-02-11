import uuid
from sqlalchemy import String
from sqlalchemy.types import TypeDecorator

class UUIDString(TypeDecorator):
    """Platform-independent UUID type.
    Uses String(36) as storage, but handles UUIDs in Python."""
    impl = String(36)
    cache_ok = True

    def process_bind_param(self, value, dialect):
        if value is None:
            return None
        elif isinstance(value, uuid.UUID):
            return str(value)
        else:
            return value

    def process_result_value(self, value, dialect):
        if value is None:
            return None
        else:
            return uuid.UUID(value)
