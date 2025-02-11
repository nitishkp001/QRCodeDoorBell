# QR Code Doorbell Video Call App - Development Plan

## A. Flutter Mobile App Implementation

1. **Project Setup**
   - Create a new Flutter project with latest SDK
   - Set up project structure (MVC pattern)
   - Configure dependencies in `pubspec.yaml`
   - Essential packages: `webrtc_flutter`, `qr_code_scanner`, `firebase_messaging`, `http`

2. **Core Features**

   a. **Authentication Module**
   - Login/Registration screens
   - JWT token management
   - Secure storage for credentials
   
   b. **QR Code Scanner**
   - Camera integration
   - QR code scanning functionality
   - Error handling for invalid QR codes
   
   c. **Video Call Interface**
   - WebRTC implementation
   - Camera preview
   - Call controls (accept/reject/end)
   - Audio toggle
   - Video quality settings
   
   d. **Notifications**
   - Firebase Cloud Messaging integration
   - Push notification handling
   - Background notification support
   
   e. **User Dashboard**
   - QR code management
   - Call history
   - Profile management
   - Settings

3. **UI/UX Components**
   - Custom theme implementation
   - Responsive layouts
   - Loading indicators
   - Error handling screens
   - Call status indicators

## B. Python Backend Implementation

1. **Project Setup**
   - FastAPI framework setup
   - PostgreSQL database setup
   - Project structure setup (Repository pattern)
   - Docker configuration

2. **Core Components**

   a. **Authentication Service**
   ```python
   - JWT token generation/validation
   - User management
   - Role-based access control
   ```

   b. **QR Code Service**
   ```python
   - QR code generation
   - QR code validation
   - QR code management (refresh/revoke)
   ```

   c. **WebRTC Signaling Server**
   ```python
   - WebSocket implementation
   - Session management
   - ICE candidate exchange
   - SDP exchange
   ```

   d. **Notification Service**
   ```python
   - Firebase integration
   - Push notification sending
   - Email notification system
   ```

3. **Database Schema**

   ```sql
   Users Table:
   - id (UUID)
   - email
   - password_hash
   - role
   - created_at
   
   QRCodes Table:
   - id (UUID)
   - user_id (FK)
   - code_data
   - is_active
   - created_at
   - expires_at
   
   CallLogs Table:
   - id (UUID)
   - qr_code_id (FK)
   - visitor_id
   - start_time
   - end_time
   - status
   ```

4. **API Endpoints**

   ```python
   # Authentication
   POST /api/auth/register
   POST /api/auth/login
   POST /api/auth/refresh-token
   
   # QR Code Management
   POST /api/qr/generate
   DELETE /api/qr/{id}
   PUT /api/qr/{id}/refresh
   
   # Call Management
   POST /api/calls/initiate
   POST /api/calls/{id}/end
   GET /api/calls/history
   
   # Notifications
   POST /api/notifications/send
   PUT /api/notifications/settings
   ```

5. **WebRTC Implementation**
   ```python
   - STUN/TURN server configuration
   - Media server integration
   - Connection handling
   - Stream management
   ```

## C. Development Phases

1. **Phase 1: Basic Setup**
   - Project structure setup
   - Database setup
   - Basic authentication

2. **Phase 2: Core Features**
   - QR code generation/scanning
   - WebRTC implementation
   - Basic call functionality

3. **Phase 3: Enhanced Features**
   - Push notifications
   - Call history
   - User dashboard

4. **Phase 4: Security & Optimization**
   - Security hardening
   - Performance optimization
   - Error handling
   - Testing

5. **Phase 5: Deployment**
   - CI/CD setup
   - Production deployment
   - Monitoring setup
