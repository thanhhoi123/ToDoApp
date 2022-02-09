import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  String? id;
  String? title, content;
  DateTime? dueDate;
  bool? isDone, isFavorite, isTimeUp;

  Todo({
    required this.id,
    required this.title,
    required this.content,
    required this.dueDate,
    required this.isDone,
    required this.isFavorite, 
    required this.isTimeUp
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'due_date': dueDate,
    'is_done': isDone,
    'is_favorite': isFavorite,
    'is_time_up': isTimeUp
  };

  static Todo fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    dueDate: (json['due_date'] as Timestamp).toDate(),
    isDone: (json['is_done'] as bool),
    isFavorite: (json['is_favorite'] as bool),
    isTimeUp: (json['is_time_up'] as bool)
  );
}