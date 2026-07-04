# UrusWang Money Manager App

## Overview
UrusWang is a personal finance management application built with Flutter. Developed as a final year project, it uniquely integrates tracking for **daily financial transactions** (income, expenses, budgets) and **debt-related transactions** (money owed to or by the user) into a single, centralized platform. This addresses a gap identified in the Malaysian market, where such apps typically handle only one type of transaction.

## Features
* **Unified Dashboard**: View all your financial activities, including regular transactions and debts, in one place
* **Debt & Loan Tracking**: Easily manage money you owe to others and money others owe you
* **Budget Management**: Set budgets for different categories and monitor your spending
* **Visual Analytics**: Gain insights through graphical summaries and reports of your financial status
* **Cross-Platform Support**: Runs on both Android and iOS devices

## Technology Stack
* **Framework**: Flutter
* **Language**: Dart
* **Database**: SQLite (via Drift)
* **Platform Support**: Android

## Project Structure
```
uruswang_money_manager_app/
├── android/          # Android-specific files
├── ios/              # iOS-specific files
├── lib/              # Main Dart source code
├── assets/           # Images, fonts, and other assets
├── web/              # Web-specific files
├── linux/            # Linux-specific files
├── macos/            # macOS-specific files
├── windows/          # Windows-specific files
├── test/             # Unit and widget tests
├── pubspec.yaml      # Project dependencies and metadata
└── README.md         # Project documentation
```

## Getting Started

### Prerequisites
* Flutter SDK (latest stable version)
* Android Studio / VS Code with Flutter plugins
* For Android development: Android SDK

### Installation

1. **Clone the repository**
   ```
   git clone https://github.com/nuaimman02/uruswang_money_manager_app.git
   ```

2. **Navigate to the project directory**
   ```
   cd uruswang_money_manager_app
   ```

3. **Install dependencies**
   ```
   flutter pub get
   ```

4. **Run the application**
   ```
   flutter run
   ```

5. **Build for specific platforms**
   ```
   flutter build apk      # Android
   ```

## Important Notes for Developers

### Date/Time Handling
Based on the developer's experience with SQLite/Drift:
- **When inserting**: Explicitly use `toUtc()` for DateTime values
- **When reading**: Explicitly use `toLocal()` for DateTime values
- The current codebase may not fully implement this pattern, presenting an opportunity for improvement

### Data Fetching Patterns
Two approaches are implemented:
- **Stream**: For real-time data updates
- **Future**: For one-time data fetching

### Development Lessons
The developer shared valuable insights from the project journey:
1. **Database Selection**: Take time to research and test databases before committing
2. **Code Comments**: Well-commented code is crucial, especially for beginners
3. **Start Simple**: Build from scratch rather than trying to reuse complex, uncommented code from other projects
4. **Stay Calm**: Development challenges are part of the process; stay focused and persistent

## Project Status

**Current Status**: Completed and presented on January 27, 2025

**Maintenance**: Active development has been paused since the presentation

**Future Development**: Contributions are welcome! The developer encourages the community to improve and enhance the application

## Potential Areas for Improvement

- [ ] Implement recommended DateTime handling (toUtc() / toLocal())
- [ ] Add comprehensive code documentation
- [ ] Enhance UI/UX design
- [ ] Add data export/backup functionality
- [ ] Implement data synchronization across devices
- [ ] Add more detailed financial reports
- [ ] Include recurring transaction support
- [ ] Improve error handling and user feedback

## Contributors
**Developer**: Nu'aimman Dinie Roslan Ismani
**Supervisor**: Dr. Muhammad Daniel Hafiz Abdullah

**Accessors**: 
- Prof. Madya Dr. Teh Noranis Mohd Aris
- Dr. Syaifulnizam Abd Manaf

**Institution**: Universiti Putra Malaysia (UPM)

## Acknowledgments

This project was developed to fulfill Final Year Project (FYP) requirements for the Bachelor in Computer Science with Honours degree at UPM.

Special thanks to:
- The supervisor and accessors for their guidance
- Family and loved ones for their support
- The open-source community for providing the tools and libraries

## License

All Rights Reserved

For permission to use, modify, or distribute, please contact the original developer.

---

## About the Name

**"UrusWang"** is a combination of the Malay words:
- **"Urus"** - meaning "to manage" or "to organize"
- **"Wang"** - meaning "money"

Together, it translates to "Manage Money" - reflecting the app's core purpose of helping users organize their finances, both regular transactions and debts.

---

*Last Updated: January 30, 2025*
