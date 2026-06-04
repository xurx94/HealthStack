```markdown
# 🏥 HealthStack

HealthStack is a secure, cross-platform mobile health management application built with Flutter. It addresses the fragmentation of personal health data by consolidating medicine scheduling, symptom logging, and medical report storage into a single, offline-first environment. 

Designed with a strict **Privacy-by-Design** architecture, HealthStack keeps sensitive medical data encrypted locally on the user's device, while leveraging Google's Gemini AI to provide easy-to-understand, localized (Bengali) explanations of complex medical reports.

## ✨ Key Features

* **🔒 Offline-First & Encrypted:** All health data is encrypted on-device using AES-256 via Hive. No sensitive data is transmitted to third-party cloud servers.
* **🤖 AI Report Analysis:** Users can upload medical reports (PDF/Images) to the encrypted vault. Using the Gemini API, the app extracts key vitals and generates a plain-language summary in Bengali to help patients understand their diagnostics.
* **💊 Medicine Tracker & Reminders:** Schedule doses with customizable frequencies. The app uses local push notifications to alert users at the exact time, even when the app is closed.
* **🤒 Symptom Logger:** Record and categorize daily symptoms. View historical symptom timelines to share with healthcare professionals during visits.
* **📊 Health Status Dashboard:** Computes real-time BMI and analyzes user-entered heart rate and blood pressure against standard clinical thresholds.
* **👤 Profile Management:** Store critical health conditions, allergies, emergency contacts, and hospital details locally.

## 🛠️ Technology Stack

* **Frontend:** Flutter & Dart
* **Local Database:** Hive (NoSQL, lightweight, fast read/write)
* **State Management:** Provider
* **AI Engine:** Google Gemini API (Generative AI SDK)
* **Security:** `flutter_secure_storage` (Hardware Keystore), `flutter_dotenv` (Environment Variables)
* **Notifications:** `flutter_local_notifications`, `timezone`

## 🚀 Getting Started

Follow these steps to run HealthStack locally on your machine.

### Prerequisites
* Flutter SDK (v3.x)
* Dart SDK
* An active [Google Gemini API Key](https://aistudio.google.com/)

### Installation

1. **Clone the repository**
   ```bash
   git clone [https://github.com/enayet/HealthStack.git](https://github.com/enayet/HealthStack.git)
   cd HealthStack

```

2. **Install dependencies**
```bash
flutter pub get

```

3. **Set up the Environment Variables (CRITICAL)**
For security reasons, the Gemini API key is excluded from version control. You must create a secret file to enable the AI scanning features.
* In the root folder of the project (same level as `pubspec.yaml`), create a new file named exactly: `.env`
* Open the `.env` file and add your Gemini API key:
```env
GEMINI_API_KEY=your_actual_api_key_here

```

4. **Run the App**
```bash
flutter run

```

## Just check the release if you don't want these installation hustles

## 🔐 Architecture Notes

HealthStack follows the **Provider** architectural pattern, separating the application into distinct layers:

* **Data Layer:** Handles all Hive database interactions and AES-256 encryption. The encryption key is generated on the first launch and secured using the device's native hardware keystore (Android Keystore / iOS Keychain).
* **State Management Layer:** `ChangeNotifier` classes (`MediManager`, `AppState`, etc.) expose reactive data streams to the UI.
* **Presentation Layer:** Material Design 3 compliant Flutter widget hierarchy.

**Phase 2 Production Roadmap:** Currently, the Gemini API key is secured locally using an injected `.env` file for prototype demonstration. In future production releases, the AI network requests will be routed through a Backend Proxy (e.g., Firebase Cloud Functions) to completely isolate the API key from the client APK.

## 📱 Screenshots

*(Add screenshots of your UI here! Good examples include the Dashboard, AI Analysis Popup, Medicine Tracker, and Health Stats)*

|  |  |  |
| --- | --- | --- |
| **Smart Dashboard** | **Upload & Scan** | **Bangla AI Overview** |


## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

```

```