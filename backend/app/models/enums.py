from enum import Enum, auto

class UserRole(str, Enum):
    ADMIN = "admin"
    OWNER = "owner"
    VISITOR = "visitor"
