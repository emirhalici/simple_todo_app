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

  TodoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        priority = json['priority'] as int,
        createdAt = DateTime.parse(json['created_at']),
        isDone = json['is_done'] as bool,
        userId = json['user'] as String,
        todo = json['todo'] as String;

  TodoModel.copyFrom(TodoModel todoModel)
      : id = todoModel.id,
        priority = todoModel.priority,
        createdAt = todoModel.createdAt,
        isDone = todoModel.isDone,
        userId = todoModel.userId,
        todo = todoModel.todo;

  static List<TodoModel> getTodoListFromJson(Map<String, dynamic> json) {
    List<TodoModel> list = [];

    for (var element in json['todos']) {
      list.add(TodoModel.fromJson(element));
    }

    return list;
  }
}
