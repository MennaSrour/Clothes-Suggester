/// Model class representing a Zikr task
/// Contains the text of the zikr and the required count
class TaskModel {
  final String id;
  final String text;
  final int count;
  final String? audioPath; // Optional path to audio file

  TaskModel({
    required this.id,
    required this.text,
    required this.count,
    this.audioPath,
  });

  /// Create a TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      text: json['text'] as String,
      count: json['count'] as int,
      audioPath: json['audioPath'] as String?,
    );
  }

  /// Convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'count': count,
      'audioPath': audioPath,
    };
  }

  /// Create a copy of the TaskModel with updated values
  TaskModel copyWith({
    String? id,
    String? text,
    int? count,
    String? audioPath,
  }) {
    return TaskModel(
      id: id ?? this.id,
      text: text ?? this.text,
      count: count ?? this.count,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, text: $text, count: $count, audioPath: $audioPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel &&
        other.id == id &&
        other.text == text &&
        other.count == count &&
        other.audioPath == audioPath;
  }

  @override
  int get hashCode {
    return id.hashCode ^ text.hashCode ^ count.hashCode ^ audioPath.hashCode;
  }
}
