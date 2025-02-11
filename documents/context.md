# QR Code Doorbell Video Call App - Requirement Document

## 1. **Project Overview**
The QR Code Doorbell Video Call App allows visitors to initiate a video call with homeowners by scanning a QR code at the entrance. The system facilitates real-time communication using WebRTC, providing a seamless, contactless, and secure way for visitors to connect with residents.

## 2. **Key Features**
### 2.1 **QR Code Generation & Management**
- Generate a unique QR code for each property.
- QR code links to a secure video call session.
- QR codes can be refreshed or invalidated by the homeowner.

### 2.2 **Video Call Functionality (WebRTC)**
- WebRTC-based real-time video and audio communication.
- High-quality, low-latency streaming.
- Automatic call establishment upon QR code scan.

### 2.3 **Visitor & Call Notifications**
- Homeowners receive push notifications when a visitor scans the QR code.
- Optional email notifications for missed calls.

### 2.4 **Access Control & Security**
- OTP or PIN-based access verification (optional).
- Encrypted communication using SSL/TLS.
- Call logs maintained for security purposes.

### 2.5 **Admin Panel**
- Dashboard for managing QR codes and call logs.
- Analytics on visitor frequency and call history.

## 3. **User Roles & Permissions**
### 3.1 **Visitor**
- Scans the QR code to initiate a video call.
- Can only access the call interface (no admin privileges).

### 3.2 **Homeowner**
- Receives call notifications.
- Can accept or decline incoming calls.
- Can refresh or revoke QR codes.

### 3.3 **Admin**
- Manages user accounts and permissions.
- Monitors system activity and logs.

## 4. **Technology Stack**
| Component | Technology |
|-----------|------------|
| Frontend | Next.js (React), TailwindCSS |
| Backend | Node.js (Express.js/NestJS) |
| Database | MongoDB / PostgreSQL |
| Video Call | WebRTC |
| Signaling | WebSockets (Socket.io) |
| Notifications | Firebase Cloud Messaging (FCM) |
| QR Code Generation | qrcode.react or qrcode.js |
| Deployment | AWS / DigitalOcean / Vercel |

## 5. **System Workflow**
1. Visitor scans the QR code on the door.
2. A WebRTC video call request is initiated.
3. Homeowner receives a push notification.
4. Homeowner accepts the call to communicate.
5. Call logs are recorded for security.
6. Optional PIN verification for access.

## 6. **API Requirements**
### 6.1 **QR Code API**
- `POST /generate-qr` → Generates a QR code.
- `DELETE /invalidate-qr/:id` → Revokes an existing QR code.

### 6.2 **Video Call API**
- `POST /start-call/:id` → Initiates a call.
- `POST /end-call/:id` → Ends an ongoing call.

### 6.3 **Notification API**
- `POST /send-notification` → Sends a push notification to the homeowner.

## 7. **Deployment & Scalability Considerations**
- **Load Balancing:** Use Nginx for distributing WebRTC traffic.
- **Database Scaling:** Deploy MongoDB Atlas / AWS RDS for high availability.
- **Serverless Option:** Use AWS Lambda for QR code generation APIs.
- **Security:** Enforce JWT-based authentication for API access.

## 8. **Future Enhancements**
- **Smart Lock Integration:** Unlock door via mobile app.
- **AI Visitor Recognition:** Capture visitor images for verification.
- **Voice Assistant Support:** Integrate with Alexa/Google Assistant.

---
### **Conclusion**
This document outlines the functional, technical, and security requirements for the QR Code Doorbell Video Call App. The app will enhance convenience and security for homeowners by enabling seamless visitor interactions through WebRTC.