enum Priority { low, medium, high }

class Issue {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final Priority priority;
  final String? location;
  final String? imageUrl;
  final String? category;

  Issue({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    required this.priority,
    this.location,
    this.imageUrl,
    this.category,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      priority: Priority.values[json['priority'] ?? 1],
      location: json['location'],
      imageUrl: json['imageUrl'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority.index,
      'location': location,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  Issue copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    Priority? priority,
    String? location,
    String? imageUrl,
    String? category,
  }) {
    return Issue(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }
} 