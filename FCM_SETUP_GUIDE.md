# 🧠 FCM IMPLEMENTATION GUIDE - ROOKIE APP

## ✅ Implementation Status

The Flutter app has been updated with complete Firebase Cloud Messaging (FCM) support. Here's what has been implemented:

### 📦 Changes Made

1. **Updated `pubspec.yaml`**
   - Added `firebase_core: ^3.8.0`
   - Added `firebase_messaging: ^15.1.0`

2. **Created `lib/services/firebase_service.dart`**
   - Firebase initialization
   - Device token retrieval
   - Server token registration
   - Foreground notification handling
   - Background message handling
   - Terminated app notification handling
   - Topic subscription management

3. **Updated `lib/main.dart`**
   - Firebase initialization in main()
   - Background message handler setup
   - FCM setup in `_setupFCM()` method
   - Foreground message listener

4. **Updated `lib/services/api_service.dart`**
   - Added `saveFCMToken()` method
   - Added `getFCMToken()` method

5. **Updated Android Configuration**
   - Added Google Services plugin to `android/build.gradle.kts`
   - Applied Google Services plugin in `android/app/build.gradle.kts`

---

## 🚀 NEXT STEPS FOR SETUP

### Step 1️⃣: Get Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new Firebase Project or select existing
3. Create an Android App in the project
4. Download `google-services.json`
5. Place it in: `android/app/google-services.json`

### Step 2️⃣: Download Firebase Admin Key

1. In Firebase Console, go to **Project Settings**
2. Navigate to **Service Accounts** tab
3. Click **Generate New Private Key**
4. Save as `firebase_key.json`
5. Keep this **secret and safe** - it's for your Python server

### Step 3️⃣: Update Server URL in main.dart

In `lib/main.dart`, update the `_setupFCM()` method:

```dart
void _setupFCM() async {
  // Listen for foreground messages
  FirebaseService.listenForegroundMessages();
  
  // Listen for terminated messages (app opened from notification)
  await FirebaseService.listenTerminatedMessages();
  
  // Get device token and send to server
  String? deviceToken = await FirebaseService.getDeviceToken();
  if (deviceToken != null) {
    // ✏️ CHANGE THIS TO YOUR ACTUAL SERVER URL
    String serverUrl = 'http://192.168.1.10:8000';
    await FirebaseService.sendTokenToServer(deviceToken, serverUrl);
  }
}
```

### Step 4️⃣: Install Dependencies

```bash
flutter pub get
```

---

## 🐍 PYTHON SERVER SETUP

Create the following structure on your RTX3050 server:

### File Structure

```
ROOKIE_3050_SERVER/
│
├── notifications/
│   ├── __init__.py
│   ├── firebase.py
│   ├── alerts.py
│   ├── device_store.py
│   └── routes.py
│
├── firebase_key.json
├── main.py
└── requirements.txt
```

### 📋 requirements.txt

```
fastapi==0.104.1
uvicorn==0.24.0
firebase-admin==6.2.0
python-multipart==0.0.6
```

### 🔥 notifications/firebase.py

```python
import firebase_admin
from firebase_admin import credentials
from firebase_admin import messaging

# =====================================================
# INIT FIREBASE
# =====================================================

cred = credentials.Certificate("firebase_key.json")
firebase_admin.initialize_app(cred)

# =====================================================
# SEND NOTIFICATION
# =====================================================

def send_push_notification(token, title, body, data=None):
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        data=data if data else {},
        token=token
    )
    
    response = messaging.send(message)
    print("✅ Notification Sent:", response)
```

### 📱 notifications/device_store.py

```python
# Device token storage (in production, use a database)
device_tokens = set()
```

### 🚨 notifications/alerts.py

```python
from notifications.firebase import send_push_notification
from notifications.device_store import device_tokens

# =====================================================
# THEFT ALERT
# =====================================================

def send_theft_alert(camera_id="CAM_1"):
    for token in device_tokens:
        send_push_notification(
            token,
            "🚨 Theft Detected",
            "Suspicious activity detected.",
            {
                "type": "theft",
                "camera": camera_id
            }
        )

# =====================================================
# FIRE ALERT
# =====================================================

def send_fire_alert(camera_id="CAM_2"):
    for token in device_tokens:
        send_push_notification(
            token,
            "🔥 Fire Detected",
            "Smoke or flame detected.",
            {
                "type": "fire",
                "camera": camera_id
            }
        )

# =====================================================
# INTRUSION ALERT
# =====================================================

def send_intrusion_alert(camera_id="CAM_3"):
    for token in device_tokens:
        send_push_notification(
            token,
            "🚪 Intrusion Detected",
            "Unauthorized person detected.",
            {
                "type": "intrusion",
                "camera": camera_id
            }
        )
```

### 📡 notifications/routes.py

```python
from fastapi import APIRouter
from pydantic import BaseModel
from notifications.device_store import device_tokens

router = APIRouter()

# =====================================================
# MODEL
# =====================================================

class DeviceToken(BaseModel):
    token: str

# =====================================================
# REGISTER TOKEN
# =====================================================

@router.post("/register-device")
async def register_device(data: DeviceToken):
    device_tokens.add(data.token)
    print(f"\n📱 DEVICE REGISTERED: {data.token}")
    return {
        "status": "registered",
        "total_devices": len(device_tokens)
    }

# =====================================================
# GET REGISTERED DEVICES
# =====================================================

@router.get("/registered-devices")
async def get_devices():
    return {
        "count": len(device_tokens),
        "devices": list(device_tokens)
    }

# =====================================================
# UNREGISTER DEVICE
# =====================================================

@router.post("/unregister-device")
async def unregister_device(data: DeviceToken):
    device_tokens.discard(data.token)
    print(f"\n📱 DEVICE UNREGISTERED: {data.token}")
    return {
        "status": "unregistered",
        "total_devices": len(device_tokens)
    }
```

### 📄 notifications/__init__.py

```python
# Empty file to make notifications a package
```

### 🚀 main.py

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from notifications.routes import router

app = FastAPI(title="Rookie 3050 Server")

# =====================================================
# CORS CONFIGURATION
# =====================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =====================================================
# INCLUDE ROUTES
# =====================================================

app.include_router(router)

# =====================================================
# HEALTH CHECK
# =====================================================

@app.get("/health")
async def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

---

## 🎯 USAGE IN YOUR AI DETECTION CODE

When your AI system detects an event:

```python
from notifications.alerts import send_theft_alert, send_fire_alert, send_intrusion_alert

# Example in your AI detection module
if theft_detected:
    print("🚨 THEFT DETECTED")
    send_theft_alert(camera_id="CAM_1")

elif fire_detected:
    print("🔥 FIRE DETECTED")
    send_fire_alert(camera_id="CAM_2")

elif intrusion_detected:
    print("🚪 INTRUSION DETECTED")
    send_intrusion_alert(camera_id="CAM_3")
```

---

## 🔄 COMPLETE FLOW

```
1. Flutter App Starts
   ↓
2. Firebase Initializes
   ↓
3. Get FCM Device Token
   ↓
4. Send Token to RTX3050 Server
   ↓
5. Server Stores Token
   ↓
6. AI Event Occurs (Theft/Fire/Intrusion)
   ↓
7. Python Server Sends FCM Notification
   ↓
8. Mobile Receives & Shows Alert
   ↓
9. User Sees Notification in Real-Time
```

---

## 📌 IMPORTANT NOTES

### Security
- ✅ Never commit `firebase_key.json` to git
- ✅ Add to `.gitignore`: `firebase_key.json`
- ✅ Add to `.gitignore`: `google-services.json`

### Testing
- Test with real device (emulator may not receive notifications)
- Enable notification permissions on device
- Monitor Flutter console for logs with 🔔, ✅, and ❌ emojis

### Debugging
- Check [Firebase Console](https://console.firebase.google.com) for message delivery status
- In Flutter: Look for logs with "FOREGROUND MESSAGE RECEIVED", "BACKGROUND MESSAGE RECEIVED"
- On Server: Check logs for "Notification Sent" confirmations

---

## 🚀 ADVANCED FEATURES (OPTIONAL)

You can later add:

- 📸 Image snapshot notifications (send camera frame)
- 🎥 Live camera opening from notification
- 🔊 Emergency siren sound
- 📂 Notification categories/grouping
- 🎫 Notification history/archive
- 🔇 Silent notifications for backend alerts
- 🏷️ Alert severity levels
- 📍 Location tagging in alerts

---

## 📚 FILE REFERENCES

### Flutter Files Updated
- [lib/main.dart](lib/main.dart)
- [lib/services/firebase_service.dart](lib/services/firebase_service.dart)
- [lib/services/api_service.dart](lib/services/api_service.dart)
- [pubspec.yaml](pubspec.yaml)

### Android Configuration Updated
- [android/build.gradle.kts](android/build.gradle.kts)
- [android/app/build.gradle.kts](android/app/build.gradle.kts)
- [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml)

---

## ✅ CHECKLIST FOR DEPLOYMENT

- [ ] Download `google-services.json` from Firebase Console
- [ ] Place in `android/app/google-services.json`
- [ ] Download `firebase_key.json` from Firebase Console
- [ ] Create Python server structure
- [ ] Place `firebase_key.json` in Python server root
- [ ] Install Python dependencies: `pip install -r requirements.txt`
- [ ] Update server URL in `lib/main.dart`
- [ ] Test on real device (not emulator)
- [ ] Run Flutter app: `flutter run`
- [ ] Run Python server: `python main.py`
- [ ] Check Firebase Console for token registration
- [ ] Test sending notifications from Python server

---

💬 Questions? Check the logs! 🚀
