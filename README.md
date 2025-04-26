# TOT App 🐾

## Overview
TOT App is a Flutter application built for real-time dog tracking and journey history management.  
The app uses **Hive** for local database storage, **Flutter Map** for live location tracking, and **GetX** for smooth state management.

The project is designed with clean architecture: controllers, models, services, and screens are properly organized.

---

## How to Run the App

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Ashahad07/tale_of_tails_flutter.git
   cd tale_of_tails_flutter

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```


3. **Run the App**
   ```bash
   flutter run
   ```


## Features
- 📍 Live location tracking

- 🛤️ Start and stop journey recording

- 📂 Store journey history locally using Hive

- 🗺️ View journey summaries (distance, time, coordinates)

- 🚀 Smooth and responsive UI

- 🧹 Clean architecture using GetX (controllers, services)

## Code Structure

- **main.dart**: Entry point of the application where routing and initial setups are configured.
- **controllers/**: Contains GetX controllers for state management and handling business logic.
- **services/**: Manages interactions with external services (e.g., Firebase, APIs).
- **models/**: Data models representing structured data used throughout the app.
- **screens/**: UI pages/screens of the application.
- **widgets/**: Reusable custom widgets for the user interface.
- **firebase_options.dart**: Auto-generated file with Firebase configuration details.

## Libraries Used

- **GetX**: For efficient state management, dependency injection, and route management.
- **Flutter SDK**: Core framework for building cross-platform mobile applications.
- **Flutter Map** : Map integration using OpenStreetMap
- **Geolocator** : For accessing the device's GPS 