import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:simple_todo_app/helpers/database_helper.dart';
import 'package:simple_todo_app/models/todo_model.dart';
import 'package:simple_todo_app/queries.dart';

class HomeViewModel with ChangeNotifier {
  GraphQLClient? client;
  DatabaseHelper helper = DatabaseHelper();
  List<TodoModel>? mainTodos;

  Future<String> getTodos() async {
    client ??= helper.getClient();
    Map<String, dynamic>? response;
    try {
      response = await helper.runQuery(client!, Queries.getAllTodosAscQuery);
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
    Map<String, dynamic> variables = {
      'is_done': todoModel.isDone,
      'todo': todoModel.todo,
      'priority': todoModel.priority,
      'user': '07c42a78-d85f-46e8-a98b-2c3d45c3b52b',
    };

    Map<String, dynamic>? response;
    try {
      response = await helper.runMutation(client!, Queries.addQuery, variables);
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

  Future<String> editTodo(TodoModel todoModel) async {
    client ??= helper.getClient();
    Map<String, dynamic> variables = {
      '_eq': todoModel.id,
      'is_done': todoModel.isDone,
      'priority': todoModel.priority,
      'todo': todoModel.todo,
    };

    Map<String, dynamic>? response;
    try {
      response = await helper.runMutation(client!, Queries.editQuery, variables);
    } catch (e) {
      return e.toString();
    }

    if (response == null) {
      return 'Mutation returned null';
    }

    try {
      Map<String, dynamic> json = response['update_todos']['returning'][0];
      TodoModel newModel = TodoModel.fromJson(json);
      mainTodos ??= [];
      mainTodos![mainTodos!.indexWhere((element) => todoModel.id == element.id)] = newModel;
      notifyListeners();
      return 'Success';
    } catch (e) {
      return 'Mutation returned null, condition may be wrong.';
    }
  }

  Future<String> deleteTodo(TodoModel todoModel) async {
    client ??= helper.getClient();
    Map<String, dynamic> variables = {
      '_eq': todoModel.id,
    };

    Map<String, dynamic>? response;
    try {
      response = await helper.runMutation(client!, Queries.deleteQuery, variables);
    } catch (e) {
      return e.toString();
    }

    if (response == null) {
      return 'Mutation returned null';
    }

    try {
      Map<String, dynamic> json = response['delete_todos']['returning'][0];
      mainTodos ??= [];
      mainTodos!.removeWhere((element) => json['id'] as int == element.id);
      notifyListeners();
      return 'Success';
    } catch (e) {
      return 'Mutation returned null, condition may be wrong.';
    }
  }

  Future<bool> todoCardOnCheckedCallback(bool val, int todoIndex) async {
    TodoModel originalModel = mainTodos![todoIndex];
    TodoModel copy = TodoModel.copyFrom(originalModel);
    copy.isDone = val;
    try {
      String response = await editTodo(copy);
      if (response != 'Success') {
        return false;
      }
    } catch (e) {
      return false;
    }
    mainTodos![todoIndex] = copy;
    notifyListeners();
    return true;
  }
}
