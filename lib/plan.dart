enum PlanStatus { pending, completed } // Plan status enum

class Plan {
  final String id;
  String name;
  String description;
  DateTime date;
  PlanStatus status;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.status = PlanStatus.pending, // Default status is pending
  });
}
