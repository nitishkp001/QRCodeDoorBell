import json
import httpx
from typing import List, Dict, Any
from app.core.config import settings

class FirebaseManager:
    def __init__(self):
        self.fcm_url = "https://fcm.googleapis.com/v1/projects/{}/messages:send".format(
            settings.FIREBASE_PROJECT_ID
        )
        self.headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {settings.FIREBASE_SERVER_KEY}"
        }

    async def send_notification(
        self,
        tokens: List[str],
        title: str,
        body: str,
        data: Dict[str, Any] = None
    ) -> bool:
        """Send push notification to multiple devices."""
        try:
            message = {
                "notification": {
                    "title": title,
                    "body": body
                },
                "data": data or {},
                "tokens": tokens,
                "android": {
                    "priority": "high",
                    "notification": {
                        "channel_id": "calls"
                    }
                },
                "apns": {
                    "payload": {
                        "aps": {
                            "sound": "default",
                            "badge": 1,
                            "content-available": 1
                        }
                    }
                }
            }

            async with httpx.AsyncClient() as client:
                response = await client.post(
                    self.fcm_url,
                    headers=self.headers,
                    json={"message": message}
                )
                response.raise_for_status()
                return True
        except Exception as e:
            print(f"Error sending push notification: {e}")
            return False

firebase_manager = FirebaseManager()
