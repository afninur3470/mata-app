class Task {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String assignedTo;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<String> attachments;
  final List<CheckIn> checkIns;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.dueDate,
    required this.assignedTo,
    this.location,
    this.latitude,
    this.longitude,
    this.attachments = const [],
    this.checkIns = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      dueDate: json['due_date'] != null 
          ? DateTime.parse(json['due_date'] as String) 
          : null,
      assignedTo: json['assigned_to'] as String,
      location: json['location'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      checkIns: (json['check_ins'] as List<dynamic>?)
          ?.map((e) => CheckIn.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'assigned_to': assignedTo,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'attachments': attachments,
      'check_ins': checkIns.map((e) => e.toJson()).toList(),
    };
  }

  bool get isCritical => priority == 'high' && status != 'completed';
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now());
}

class CheckIn {
  final String id;
  final String taskId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String? notes;
  final List<String> photos;

  CheckIn({
    required this.id,
    required this.taskId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.notes,
    this.photos = const [],
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      notes: json['notes'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'photos': photos,
    };
  }
}
