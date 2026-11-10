import 'dart:io';

// ==========================================
// D. MIXIN
// ==========================================
mixin PrintableDetails {
  void printHeader(String title) {
    print('\n========================================');
    print('   $title');
    print('========================================');
  }

  void logAction(String message) {
    DateTime now = DateTime.now();
    print('[LOG ${now.hour}:${now.minute}:${now.second}] $message');
  }
}

// ==========================================
// D. ABSTRACT CLASS & POLYMORPHISM
// ==========================================
abstract class CenterRecord {
  final String _id; // Encapsulated private field
  String titleOrName;

  CenterRecord(this._id, this.titleOrName);

  // Getter for private field
  String get id => _id;

  // Abstract method to be implemented by subclasses
  void displayDetails();
}

// ==========================================
// C & D. SUBCLASSES & ENCAPSULATION
// ==========================================
class LearningResource extends CenterRecord with PrintableDetails {
  String _category; // Private field
  bool _isAvailable;

  LearningResource(String id, String title, this._category, [this._isAvailable = true])
      : super(id, title);

  // Getters & Setters
  String get category => _category;
  bool get isAvailable => _isAvailable;
  set isAvailable(bool status) => _isAvailable = status;

  @override
  void displayDetails() {
    String status = _isAvailable ? 'Available' : 'Borrowed';
    print('ID: $id | Title: $titleOrName | Category: $_category | Status: $status');
  }
}

class Participant extends CenterRecord with PrintableDetails {
  String _email; // Private field
  int _borrowedCount;

  Participant(String id, String name, this._email, [this._borrowedCount = 0])
      : super(id, name);

  // Getters & Setters
  String get email => _email;
  int get borrowedCount => _borrowedCount;

  void incrementBorrowed() => _borrowedCount++;
  void decrementBorrowed() {
    if (_borrowedCount > 0) _borrowedCount--;
  }

  @override
  void displayDetails() {
    print('ID: $id | Name: $titleOrName | Email: $_email | Borrowed Items: $_borrowedCount');
  }
}

// ==========================================
// MAIN APPLICATION CLASS & DATA STRUCTURES
// ==========================================
class LearningCenterApp with PrintableDetails {
  // C. Lists and Maps to store records
  final List<LearningResource> _resources = [];
  final List<Participant> _participants = [];
  final Map<String, List<String>> _borrowedLog = {}; // Key: Participant ID, Value: List of Resource IDs

  // Sample Pre-populated Data
  LearningCenterApp() {
    _resources.add(LearningResource('R101', 'Dart Programming 101', 'Book'));
    _resources.add(LearningResource('R102', 'Flutter Dev Kit', 'Hardware'));
    _participants.add(Participant('P001', 'Juan Cruz', 'juan@example.com'));
  }

  // B. USER-DEFINED FUNCTIONS WITH PARAMETERS AND RETURN VALUES/ACTIONS
  
  /// Helper 1: Find resource by ID
  LearningResource? findResourceById(String id) {
    try {
      return _resources.firstWhere((r) => r.id.toUpperCase() == id.toUpperCase());
    } catch (_) {
      return null;
    }
  }

  /// Helper 2: Find participant by ID
  Participant? findParticipantById(String id) {
    try {
      return _participants.firstWhere((p) => p.id.toUpperCase() == id.toUpperCase());
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // MENU ACTIONS & OPERATORS
  // ==========================================

  void addResource() {
    printHeader('ADD NEW RESOURCE');
    stdout.write('Enter Resource ID (e.g., R103): ');
    String? id = stdin.readLineSync()?.trim();
    if (id == null || id.isEmpty) {
      print('Error: Resource ID cannot be empty.');
      return;
    }

    if (findResourceById(id) != null) {
      print('Error: Resource ID already exists.');
      return;
    }

    stdout.write('Enter Resource Title: ');
    String? title = stdin.readLineSync()?.trim();
    stdout.write('Enter Category (Book/Equipment/Hardware): ');
    String? category = stdin.readLineSync()?.trim();

    if (title == null || title.isEmpty || category == null || category.isEmpty) {
      print('Error: All fields are required.');
      return;
    }

    _resources.add(LearningResource(id, title, category));
    logAction('Resource "$title" added successfully.');
  }

  void registerParticipant() {
    printHeader('REGISTER PARTICIPANT');
    stdout.write('Enter Participant ID (e.g., P002): ');
    String? id = stdin.readLineSync()?.trim();
    if (id == null || id.isEmpty) {
      print('Error: Participant ID cannot be empty.');
      return;
    }

    if (findParticipantById(id) != null) {
      print('Error: Participant ID already exists.');
      return;
    }

    stdout.write('Enter Full Name: ');
    String? name = stdin.readLineSync()?.trim();
    stdout.write('Enter Email Address: ');
    String? email = stdin.readLineSync()?.trim();

    if (name == null || name.isEmpty || email == null || !email.contains('@')) {
      print('Error: Invalid name or email format.');
      return;
    }

    _participants.add(Participant(id, name, email));
    logAction('Participant "$name" registered successfully.');
  }

  void processBorrowTransaction() {
    printHeader('BORROW RESOURCE TRANSACTION');
    stdout.write('Enter Participant ID: ');
    String? pId = stdin.readLineSync()?.trim();
    Participant? participant = findParticipantById(pId ?? '');

    if (participant == null) {
      print('Error: Participant not found.');
      return;
    }

    stdout.write('Enter Resource ID to borrow: ');
    String? rId = stdin.readLineSync()?.trim();
    LearningResource? resource = findResourceById(rId ?? '');

    if (resource == null) {
      print('Error: Resource not found.');
      return;
    }

    if (!resource.isAvailable) {
      print('Error: Item is currently unavailable/borrowed.');
      return;
    }

    // Process Transaction & Calculation
    resource.isAvailable = false;
    participant.incrementBorrowed();

    _borrowedLog.putIfAbsent(participant.id, () => []).add(resource.id);

    logAction('Transaction complete: ${participant.titleOrName} borrowed ${resource.titleOrName}.');
  }

  void viewAllRecords() {
    printHeader('COMMUNITY LEARNING CENTER RECORDS');

    print('\n--- LEARNING RESOURCES (${_resources.length} total) ---');
    if (_resources.isEmpty) {
      print('No resources available.');
    } else {
      // D. Polymorphism demonstration using base class reference
      for (CenterRecord item in _resources) {
        item.displayDetails();
      }
    }

    print('\n--- REGISTERED PARTICIPANTS (${_participants.length} total) ---');
    if (_participants.isEmpty) {
      print('No participants registered.');
    } else {
      for (CenterRecord person in _participants) {
        person.displayDetails();
      }
    }

    // A. Operational calculation: Calculate center utilization rate
    int totalItems = _resources.length;
    int borrowedCount = _resources.where((r) => !r.isAvailable).length;
    double utilizationRate = totalItems > 0 ? (borrowedCount / totalItems) * 100 : 0.0;

    print('\n----------------------------------------');
    print('SUMMARY STATS:');
    print('Borrowed Items: $borrowedCount / $totalItems');
    print('Resource Utilization Rate: ${utilizationRate.toStringAsFixed(1)}%');
    print('----------------------------------------');
  }

  // B. MAIN EXECUTION LOOP & ERROR HANDLING
  void run() {
    bool isRunning = true;

    while (isRunning) {
      printHeader('COMMUNITY LEARNING CENTER SYSTEM');
      print('1. Add Learning Resource');
      print('2. Register Participant');
      print('3. Borrow Resource (Transaction)');
      print('4. View All Records & Summary');
      print('5. Exit Application');
      stdout.write('\nSelect an option (1-5): ');

      try {
        String? input = stdin.readLineSync();
        int? choice = int.tryParse(input ?? '');

        switch (choice) {
          case 1:
            addResource();
            break;
          case 2:
            registerParticipant();
            break;
          case 3:
            processBorrowTransaction();
            break;
          case 4:
            viewAllRecords();
            break;
          case 5:
            print('\nExiting application. Thank you!');
            isRunning = false;
            break;
          default:
            print('\n[Invalid Option] Please enter a number between 1 and 5.');
        }
      } catch (e) {
        print('\nAn unexpected error occurred: $e');
      }
    }
  }
}

void main() {
  LearningCenterApp app = LearningCenterApp();
  app.run();
}