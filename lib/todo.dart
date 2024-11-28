import 'package:hive/hive.dart';
part 'todo.g.dart';





@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  String task;

  @HiveField(1)
  bool isCompleted;

  Todo({required this.task, this.isCompleted = false});

  void save() {}
}
