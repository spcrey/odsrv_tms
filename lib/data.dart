class User {
  String name;
  String phoneNumber;
  String? email;

  User(this.name, {
    required this.phoneNumber,
    this.email
  });
}

enum TaskStatus {
  queueing, inProgress, completed,
}

enum TaskType {
  training, evaluation, visualation,
}

class Task {
  final String name;
  final TaskStatus status;
  final DateTime dateTime;
  final TaskType type;

  Task(this.name, {
    required this.status,
    required this.dateTime,
    required this.type,
  });
}
