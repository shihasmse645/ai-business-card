AI Business Card Scanner App

A Flutter application that scans visiting cards using AI (OCR), extracts contact details, saves them to Google Sheets, and displays them in a searchable dashboard.

🚀 Project Overview

This application allows users to:

📸 Upload front & back images of a business card

🤖 Extract text using AI (Google ML Kit OCR)

🧠 Parse and identify:

Name

Company

Phone

Email

Website

☁️ Save extracted data to Google Sheets

📊 View saved contacts in a dashboard

📞 Call directly from the app

💬 Open WhatsApp chat instantly

🛠 Tech Stack

Flutter 3.35

Dart SDK 3.9.2

State Management: Provider

OCR: google_mlkit_text_recognition

API Calls: dio

Google Sheets: Google Apps Script Webhook

Image Picker: image_picker

URL Launcher: url_launcher

Architecture: Clean separation with feature-based structure

📦 Dependencies Used
provider: ^6.1.5+1
image_picker: ^1.2.1
google_mlkit_text_recognition: ^0.15.1
dio: ^5.9.1
url_launcher: ^6.3.2
intl: ^0.20.2
get: ^4.7.3
http: ^1.6.0
📂 Folder Structure
lib/
├── core/
├── features/
│   ├── scan/
│   ├── dashboard/
├── services/
├── models/
Explanation

models/ → ContactModel

services/ → OCR service & Google Sheets service

features/scan/ → Upload, preview, extract logic

features/dashboard/ → Contact list, search, call, WhatsApp

core/ → Common utilities

This ensures proper separation of UI, business logic, and services.

🤖 AI (OCR) Implementation

The app uses:

google_mlkit_text_recognition
Flow:

User selects front & back images using image_picker

Images are passed to ML Kit Text Recognizer

Raw text is extracted

Custom parsing logic identifies:

Phone numbers using regex

Emails using regex

Website detection

Name & company from structured text

Missing fields are handled gracefully (null-safe)

Why ML Kit?

On-device processing

Fast performance

No external API dependency

Works offline

☁️ Google Sheets Integration

The app integrates Google Sheets using:

✅ Google Apps Script Webhook
Flow:

A Google Sheet is created with columns:

| Name | Company | Phone | Email | Website | Date |

Google Apps Script is deployed as Web App.

A POST API endpoint is generated.

Flutter app sends extracted data using dio.

Sample Payload
{
  "name": "John Doe",
  "company": "ABC Pvt Ltd",
  "phone": "+919999999999",
  "email": "john@email.com",
  "website": "www.abc.com",
  "date": "2026-03-01"
}

Script appends the row to the sheet.

Error Handling

Try-catch implemented

API failure handled

Loading indicator shown during save

User feedback message displayed

📊 Dashboard Screen

After saving, contacts are displayed in a dashboard.

Features:

Search functionality

Scrollable contact list

Clickable contact card

Call button:

tel:+919999999999

WhatsApp button:

https://wa.me/919999999999

Using:

url_launcher
🧠 State Management

Used:

Provider
Providers Implemented:

ScanProvider → Handles image selection, OCR, save

DashboardProvider → Fetches and manages contact list

Why Provider?

Lightweight

Simple

Clean separation of UI & logic

Ideal for small-medium applications

🧼 Code Quality

✔ Null Safety enabled
✔ Proper error handling
✔ Loading indicators
✔ No UI logic inside services
✔ Clean separation
✔ Try-catch for API calls
✔ Responsive layout

⚙️ Setup Instructions
1️⃣ Clone Repository
git clone <your-repo-link>
cd businesscardapp
2️⃣ Install Dependencies
flutter pub get
3️⃣ Configure Google Sheets

Create a new Google Sheet

Add columns:

Name | Company | Phone | Email | Website | Date

Open Extensions → Apps Script

Paste Apps Script webhook code

Deploy as Web App

Copy Web App URL

Replace the URL in:

google_sheets_service.dart
4️⃣ Run App
flutter run
📱 Platform Permissions
Android

Camera permission

Internet permission

iOS

Camera usage description

Photo library usage description

🎯 Evaluation Criteria Covered

✔ OCR Implementation
✔ Google Sheets Integration
✔ State Management
✔ Clean Architecture
✔ Dashboard Functionality
✔ Call & WhatsApp Integration
✔ Error Handling
✔ Code Quality
