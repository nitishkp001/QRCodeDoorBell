from typing import Dict, Set
from fastapi import WebSocket

class SignalingManager:
    def __init__(self):
        self.active_connections: Dict[str, Dict[str, WebSocket]] = {}

    async def connect(self, websocket: WebSocket, call_id: str, user_id: str):
        """Add a WebSocket connection for a specific call and user."""
        if call_id not in self.active_connections:
            self.active_connections[call_id] = {}
        self.active_connections[call_id][user_id] = websocket

    def disconnect(self, call_id: str, user_id: str):
        """Remove a WebSocket connection."""
        if call_id in self.active_connections:
            self.active_connections[call_id].pop(user_id, None)
            if not self.active_connections[call_id]:
                del self.active_connections[call_id]

    async def broadcast_offer(self, call_id: str, sender_id: str, sdp: str):
        """Broadcast WebRTC offer to other participants."""
        if call_id in self.active_connections:
            for user_id, connection in self.active_connections[call_id].items():
                if user_id != sender_id:
                    await connection.send_json({
                        "type": "offer",
                        "sender_id": sender_id,
                        "sdp": sdp
                    })

    async def broadcast_answer(self, call_id: str, sender_id: str, sdp: str):
        """Broadcast WebRTC answer to other participants."""
        if call_id in self.active_connections:
            for user_id, connection in self.active_connections[call_id].items():
                if user_id != sender_id:
                    await connection.send_json({
                        "type": "answer",
                        "sender_id": sender_id,
                        "sdp": sdp
                    })

    async def broadcast_ice_candidate(self, call_id: str, sender_id: str, candidate: dict):
        """Broadcast ICE candidate to other participants."""
        if call_id in self.active_connections:
            for user_id, connection in self.active_connections[call_id].items():
                if user_id != sender_id:
                    await connection.send_json({
                        "type": "ice-candidate",
                        "sender_id": sender_id,
                        "candidate": candidate
                    })

    async def broadcast_call_ended(self, call_id: str, sender_id: str):
        """Broadcast call end signal to all participants."""
        if call_id in self.active_connections:
            for user_id, connection in self.active_connections[call_id].items():
                if user_id != sender_id:
                    await connection.send_json({
                        "type": "call-ended",
                        "sender_id": sender_id
                    })
