from fastapi import APIRouter, Depends, HTTPException, Request
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session
from app.api import deps
from app.crud import crud_qr_code
from app.core.config import settings

router = APIRouter()

@router.get("/{qr_code_id}", response_class=HTMLResponse)
async def web_call_page(
    *,
    request: Request,
    qr_code_id: str,
    db: Session = Depends(deps.get_db),
):
    """
    Web page for initiating a video call from a QR code scan.
    """
    # Check if QR code exists and is active
    qr_code = crud_qr_code.get(db=db, id=qr_code_id)
    if not qr_code:
        raise HTTPException(status_code=404, detail="QR code not found")
    if not qr_code.is_active:
        raise HTTPException(status_code=400, detail="QR code is not active")

    # Return HTML page with WebRTC video call interface
    return f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Video Call</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {{
                margin: 0;
                padding: 20px;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: #f5f5f5;
            }}
            .container {{
                max-width: 600px;
                margin: 0 auto;
                text-align: center;
            }}
            h1 {{
                color: #333;
                margin-bottom: 20px;
            }}
            #localVideo, #remoteVideo {{
                width: 100%;
                max-width: 400px;
                margin: 10px 0;
                background: #000;
                border-radius: 8px;
            }}
            .button {{
                background-color: #007AFF;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-size: 16px;
                cursor: pointer;
                margin: 10px;
            }}
            .button:disabled {{
                background-color: #ccc;
                cursor: not-allowed;
            }}
            .status {{
                margin: 10px 0;
                padding: 10px;
                border-radius: 4px;
            }}
            .error {{
                background-color: #ffebee;
                color: #c62828;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Video Call</h1>
            <div id="status" class="status"></div>
            <video id="localVideo" autoplay muted playsinline></video>
            <video id="remoteVideo" autoplay playsinline></video>
            <div>
                <button id="startCall" class="button">Start Call</button>
                <button id="endCall" class="button" disabled>End Call</button>
            </div>
        </div>
        <script>
            const QR_CODE_ID = '{qr_code_id}';
            const WS_URL = '{settings.WEBSOCKET_URL}';
            let peerConnection;
            let localStream;
            let ws;

            // WebRTC configuration
            const configuration = {{
                iceServers: [
                    {{ urls: 'stun:stun.l.google.com:19302' }},
                ]
            }};

            async function startCall() {{
                try {{
                    // Get local media stream
                    localStream = await navigator.mediaDevices.getUserMedia({{
                        video: true,
                        audio: true
                    }});
                    document.getElementById('localVideo').srcObject = localStream;
                    
                    // Create WebSocket connection for guest
                    const wsUrl = WS_URL + '/guest-ws/' + QR_CODE_ID;
                    ws = new WebSocket(wsUrl);
                    
                    // Set up WebSocket handlers
                    ws.onopen = () => {{
                        setStatus('Connected to signaling server');
                        setupPeerConnection();
                    }};
                    
                    ws.onmessage = async (event) => {{
                        const message = JSON.parse(event.data);
                        handleSignalingMessage(message);
                    }};
                    
                    ws.onerror = (error) => {{
                        setStatus('WebSocket error: ' + error.message, true);
                    }};
                    
                    ws.onclose = () => {{
                        setStatus('Disconnected from signaling server', true);
                        cleanup();
                    }};
                    
                    document.getElementById('startCall').disabled = true;
                    document.getElementById('endCall').disabled = false;
                }} catch (error) {{
                    setStatus('Error starting call: ' + error.message, true);
                }}
            }}

            function setupPeerConnection() {{
                peerConnection = new RTCPeerConnection(configuration);
                
                // Add local stream
                localStream.getTracks().forEach(track => {{
                    peerConnection.addTrack(track, localStream);
                }});
                
                // Handle ICE candidates
                peerConnection.onicecandidate = event => {{
                    if (event.candidate) {{
                        ws.send(JSON.stringify({{
                            type: 'ice-candidate',
                            candidate: event.candidate
                        }}));
                    }}
                }};
                
                // Handle remote stream
                peerConnection.ontrack = event => {{
                    document.getElementById('remoteVideo').srcObject = event.streams[0];
                }};
                
                // Create and send offer
                createAndSendOffer();
            }}

            async function createAndSendOffer() {{
                try {{
                    const offer = await peerConnection.createOffer();
                    await peerConnection.setLocalDescription(offer);
                    ws.send(JSON.stringify({{
                        type: 'offer',
                        sdp: offer
                    }}));
                }} catch (error) {{
                    setStatus('Error creating offer: ' + error.message, true);
                }}
            }}

            async function handleSignalingMessage(message) {{
                try {{
                    if (message.type === 'answer') {{
                        await peerConnection.setRemoteDescription(new RTCSessionDescription(message.sdp));
                    }} else if (message.type === 'ice-candidate') {{
                        await peerConnection.addIceCandidate(new RTCIceCandidate(message.candidate));
                    }} else if (message.type === 'call-ended') {{
                        cleanup();
                        setStatus('Call ended by other party');
                    }}
                }} catch (error) {{
                    setStatus('Error handling message: ' + error.message, true);
                }}
            }}

            function endCall() {{
                if (ws && ws.readyState === WebSocket.OPEN) {{
                    ws.send(JSON.stringify({{ type: 'end-call' }}));
                }}
                cleanup();
            }}

            function cleanup() {{
                if (peerConnection) {{
                    peerConnection.close();
                    peerConnection = null;
                }}
                if (localStream) {{
                    localStream.getTracks().forEach(track => track.stop());
                    localStream = null;
                }}
                if (ws) {{
                    ws.close();
                    ws = null;
                }}
                document.getElementById('localVideo').srcObject = null;
                document.getElementById('remoteVideo').srcObject = null;
                document.getElementById('startCall').disabled = false;
                document.getElementById('endCall').disabled = true;
            }}

            function setStatus(message, isError = false) {{
                const statusElement = document.getElementById('status');
                statusElement.textContent = message;
                statusElement.className = 'status' + (isError ? ' error' : '');
            }}

            // Event listeners
            document.getElementById('startCall').addEventListener('click', startCall);
            document.getElementById('endCall').addEventListener('click', endCall);
        </script>
    </body>
    </html>
    """
