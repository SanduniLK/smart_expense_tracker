# 🏦 SmartExpense Tracker
### *Automated SMS-to-Expense Converter for Flutter*

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-764ABC?style=for-the-badge&logo=dart&logoColor=white)

SmartExpense is a modern mobile application built to simplify personal finance management. It automatically parses bank SMS notifications using **Regex**, extracts critical transaction data, and organizes it into a beautiful, user-friendly dashboard.

---

## ✨ Key Features

* **🔍 Smart SMS Parsing:** No more manual entry! Paste a bank SMS, and the app instantly extracts the Amount, Merchant, Date, and Account Reference.
* **🏷️ Auto-Categorization:** Uses an intelligent keyword engine to categorize transactions into *Groceries, Fuel, Transport, Food, Utilities,* and more.
* **📊 Financial Dashboard:** View your Total Balance, Income, and Expenses at a glance with a custom-designed Indigo gradient interface.
* **🧩 Scalable Architecture:** Built with **Riverpod** for robust state management and a clean project structure.
* **🎨 Material 3 UI:** Features a modern, minimalist design with a calm Indigo color palette.

---

## 📸 App Preview

| Splash Screen | Dashboard | Add Transaction |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/57f6f70a-7965-4f30-802c-55c3258525e9" width="200" alt="Splash Screen" /> | <img src="https://github.com/user-attachments/assets/b822d561-127e-4054-9988-c77464010375" width="200" alt="Dashboard" /> | <img src="https://github.com/user-attachments/assets/94178a9c-09c3-4d4b-ba8b-70c8d103328e" width="200" alt="Add SMS" /> |

---

## 🧠 The Parsing Logic

The core "magic" happens in the `SmsParser` class. It uses multiple Regex patterns to support various Sri Lankan bank SMS formats (HNB, Sampath, ComBank, etc.).

```dart
// Example: Extracting the LKR amount from raw SMS text
final regex = RegExp(r'LKR\s+([\d,]+\.\d{2})', caseSensitive: false);
