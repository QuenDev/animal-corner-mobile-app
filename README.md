# 🐾 Animal Corner: Veterinary Care Simplified

[![Flutter](https://img.shields.io/badge/Flutter-3.5.2-02569B.svg?style=flat&logo=flutter)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Core%203.8.0-FFCA28.svg?style=flat&logo=firebase)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Animal Corner** is a comprehensive mobile solution designed to bridge the gap between pet owners and veterinary clinics. By streamlining pet profiling and appointment management, the application enhances the healthcare experience for pets while optimizing clinic operations.

---

## 🌟 Key Features

- **🐕 Advanced Pet Profiling**: Create and manage detailed digital health records for multiple pets, including photos and medical history.
- **📅 Smart Appointment Scheduling**: Integrated calendar system (`table_calendar`) for booking veterinary visits with automated date/time validation.
- **🔔 Real-Time Notifications**: Stay updated with push notifications for appointment reminders and clinic announcements via Firebase Cloud Messaging (FCM).
- **🔐 Secure Authentication**: Multi-layered security featuring Google Sign-In, Firebase Email/Password Auth, and mandatory email verification.
- **☁️ Firebase Integration**: 
  - **Cloud Firestore**: Real-time data synchronization for pet records and schedules.
  - **Firebase Storage**: Secure hosting for student and pet profile images.
  - **Offline Persistence**: Continuous access to critical data even without an active internet connection.
- **🌗 Responsive UI**: A polished, interactive experience powered by `flutter_staggered_animations` and custom glassmorphism-inspired themes.

---

## 🛠️ Technical Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **Backend-as-a-Service**: [Firebase](https://firebase.google.com/)
  - Authentication (Google & Email)
  - Cloud Firestore (NoSQL Database)
  - Cloud Storage (Media Hosting)
  - Cloud Messaging (Push Notifications)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Utilities**: `shared_preferences`, `flutter_local_notifications`

---

## 📦 Core Modules & Architecture

### 📱 Dashboard & Dashboard Navigation
Centralized hub for users to view upcoming appointments, pet statistics, and quick-action buttons for common tasks.

### 🏥 Appointment Management
A robust scheduling module that allows users to pick available slots, view historical visits, and receive local notification triggers.

### ⚙️ User Settings & Privacy
Comprehensive control over account security (Change Password), notification preferences, and transparency with built-in Terms of Service and Privacy Policy modules.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.5.2+)
- Android Studio / VS Code
- A Firebase Project (Google Services files required)

### Installation
1. **Clone the Repo**:
   ```bash
   git clone https://github.com/QuenDev/animal-corner-mobile-app.git
   ```
2. **Setup Firebase**:
   - Place your `google-services.json` in `android/app/`
   - Place your `GoogleService-Info.plist` in `ios/Runner/`
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the App**:
   ```bash
   flutter run
   ```

---

## 🤝 Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

---

## 📄 License
This project is licensed under the MIT License.
