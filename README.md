🔐 CipherVault — Password Manager App

CipherVault is a secure and modern Flutter-based password manager that allows users to safely store, encrypt, and manage their passwords across devices.
Built with Firebase, Google Sign-In, and AES encryption, it combines elegant UI with serious protection.

🧩 Features

✅ Google Sign-In — Quick and secure authentication using your Google account
✅ Password Encryption — AES encryption ensures your data stays private
✅ Firestore Integration — Cloud-based storage for access across devices
✅ Local Caching — SharedPreferences keeps your login session persistent
✅ Password Add / Delete — Manage entries dynamically with Firestore
✅ Beautiful UI — Light Blue modern design with smooth GetX state management
✅ Animated AppBar & BottomSheets — Polished transitions and micro-interactions

🛠️ Tech Stack
Category	Tech
Framework	Flutter 3.x
State Management	GetX
Backend	Firebase (Auth + Firestore)
Authentication	Google Sign-In
Encryption	AES via encrypt package
Storage	SharedPreferences
Animations	Animate_do
⚙️ Setup & Installation
1️⃣ Clone this repo:
git clone https://github.com/yourusername/ciphervault.git
cd ciphervault

2️⃣ Install dependencies:
flutter pub get

3️⃣ Set up Firebase:

Go to Firebase Console

Create a new project

Enable Authentication → Google Sign-In

Enable Cloud Firestore

Add your google-services.json (Android) and GoogleService-Info.plist (iOS)

Don’t forget to generate and paste your firebase_options.dart

4️⃣ Run the app:
flutter run