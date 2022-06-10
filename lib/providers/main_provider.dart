import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:simple_todo_app/helpers/database_helper.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class MainProvider with ChangeNotifier {
  GraphQLClient? client;
  DatabaseHelper helper = DatabaseHelper();
  List<TodoModel>? mainTodos;

  Future<String> getTodos() async {
    client ??= helper.getClient();
    String query = r'''
    query {
      todos(order_by: {created_at: asc}) {
        id
        priority
        todo
        created_at
        is_done
        user
        }
    }
    ''';
    Map<String, dynamic>? response;
    try {
      response = await helper.runQuery(client!, query);
    } catch (e) {
      return e.toString();
    }

    if (response == null) {
      return 'Query returned null';
    }
    mainTodos = TodoModel.getTodoListFromJson(response);
    notifyListeners();
    return 'Success';
  }

  Future<String> addTodo(TodoModel todoModel) async {
    client ??= helper.getClient();
    Map<String, dynamic>? response;
    try {
      response = await helper.runCreateMutation(client!, todoModel);
    } catch (e) {
      return e.toString();
    }

    if (response == null) {
      return 'Mutation returned null';
    }
    TodoModel newModel = TodoModel.fromJson(response['insert_todos_one']);
    mainTodos ??= [];
    mainTodos!.add(newModel);
    notifyListeners();
    return 'Success';
  }
}
