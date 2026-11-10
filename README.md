# Community Learning Center Management System
**Mobile Development Midterm Laboratory Examination**

* **Student Name:** [Your Full Name]
* **Section:** [Your Section]
* **Repository Name:** MD_Midterm_[Surname]_[Section]

---

## Application Overview
The Community Learning Center Management System is an integrated Dart console application designed to register learning resources, keep track of participants, process borrow transactions, and generate center utilization reports.

## Key Features Implemented

1. **Console Menu & Navigation:** Loop-driven interactive main menu with input validation.
2. **Object-Oriented Architecture (OOP):**
   * **Abstract Base Class:** `CenterRecord` serves as the foundation for common records.
   * **Encapsulation:** Private properties (`_id`, `_category`, `_email`) exposed safely via getters and setters.
   * **Inheritance & Polymorphism:** `LearningResource` and `Participant` inherit from `CenterRecord` and override `displayDetails()`.
   * **Mixins:** `PrintableDetails` provides reusable formatting and logging functionality.
3. **Data Storage & Tracking:** Uses `List` structures for active resources/participants and `Map` structures to log active borrow records.
4. **Calculations:** Real-time center utilization rate calculation: $(\text{Borrowed Items} / \text{Total Items}) \times 100$.

---

## How to Run the Application

### Prerequisites
* [Dart SDK](https://dart.dev/get-dart) installed locally **OR** use [DartPad](https://dartpad.dev) (Console mode).

### Execution Steps
1. Clone this repository:
   ```bash
   git clone [https://github.com/](https://github.com/)[YourUsername]/MD_Midterm_[Surname]_[Section].git
