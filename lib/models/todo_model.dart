class TodoModel {
  int id;
  DateTime createdAt;
  String todo;
  String userId;
  bool isDone;
  int priority;

  TodoModel({
    required this.id,
    required this.createdAt,
    required this.todo,
    required this.userId,
    required this.isDone,
    required this.priority,
  });
}
