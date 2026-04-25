# 🏦 SmartExpense Tracker
### *Automated SMS-to-Expense Converter*

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-764ABC?style=for-the-badge&logo=dart&logoColor=white)

SmartExpense is a modern Flutter application designed to simplify personal finance. It "listens" to your bank SMS notifications, extracts complex data using **Regex**, and organizes everything into a beautiful dashboard.

---

## ✨ Why SmartExpense?

Tracking expenses manually is boring. **SmartExpense** does the hard work for you:
* **🔍 Smart Parsing:** No more manual entry. Paste an SMS, and the app knows the amount, merchant, and date.
* **🏷️ Auto-Categorization:** It knows "Keells" is *Groceries* and "Ceypetco" is *Fuel*.
* **📊 Visual Insights:** See your income vs. expenses at a glance with a clean Material 3 UI.
* **⚡ Built for Speed:** Minimalist architecture using Riverpod for lightning-fast state updates.

---

## 📸 App Preview

| Splash Screen | Dashboard | Add Transaction |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/200x400?text=Splash+Screen" width="200" /> | (https://github.com/SanduniLK/smart_expense_tracker/issues/3#issue-4328816705) | <img src="https://via.placeholder.com/200x400?text=Add+SMS" width="200" /> |
> *Tip: Replace these placeholders with your actual app screenshots to make it 100% attractive!*

---

## 🛠️ The "Magic" Behind Parsing

The core of this app is the **SmsParser**. It uses advanced Regular Expressions (Regex) to handle various Sri Lankan bank formats:

```dart
// Example of how we extract the amount
final regex = RegExp(r'LKR\s+([\d,]+\.\d{2})', caseSensitive: false);
