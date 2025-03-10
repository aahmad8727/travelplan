enum PlanStatus { pending, completed } // enum
enum Priority { low, medium, high } // enum

class Plan { // class
  final String id;
  String name;
  String description;
  DateTime date;
  PlanStatus status;
  Priority priority; 

  Plan({ // constructor
    required this.id,
    required this.name,
    required this.description,
    required this.date, 
    this.status = PlanStatus.pending // status
    this.priority = Priority.medium, //  priority
  });
}
