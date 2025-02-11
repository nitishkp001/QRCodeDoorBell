from typing import Any
from sqlalchemy.ext.declarative import as_declarative, declared_attr
from sqlalchemy.orm import class_mapper
from datetime import datetime
from uuid import UUID

@as_declarative()
class Base:
    id: Any
    __name__: str

    # Generate __tablename__ automatically
    @declared_attr
    def __tablename__(cls) -> str:
        return cls.__name__.lower()
    
    def to_dict(self):
        """Convert model instance to dictionary."""
        mapper = class_mapper(self.__class__)
        result = {}
        for column in mapper.column_attrs:
            value = getattr(self, column.key)
            # Convert UUID to string
            if isinstance(value, UUID):
                value = str(value)
            # Convert datetime to ISO format
            elif isinstance(value, datetime):
                value = value.isoformat()
            result[column.key] = value
        return result
