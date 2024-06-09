import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class Task {
  final int? id;
  final String todo;
  final bool completed;
  final int? userId;

  Task({
    this.id,
    required this.todo,
    required this.completed,
    this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
