import 'package:flutter/material.dart';
import 'package:simple_todo_app/models/todo_model.dart';
import 'package:simple_todo_app/project_constants.dart';
import 'package:simple_todo_app/widgets/todo_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ProjectConstants.lightTheme,
      darkTheme: ProjectConstants.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Todo'),
      ),
      body: ListView(
        children: [
          TodoCard(
            todoModel: TodoModel(
              id: 1,
              createdAt: DateTime.now(),
              todo: 'Take out the trash',
              userId: '-1',
              isDone: false,
              priority: 3,
            ),
            onCheckedCallback: (bool val) {
              print('card 1 on check $val');
            },
          ),
          TodoCard(
            todoModel: TodoModel(
              id: 2,
              createdAt: DateTime.now(),
              todo: 'Attend the meeting',
              userId: '-1',
              isDone: false,
              priority: 2,
            ),
            onCheckedCallback: (bool val) {
              print('card 2 on check $val');
            },
          ),
          TodoCard(
            todoModel: TodoModel(
              id: 3,
              createdAt: DateTime.now(),
              todo: 'Fix bug on the code',
              userId: '-1',
              isDone: true,
              priority: 1,
            ),
            onCheckedCallback: (bool val) {
              print('card 3 on check $val');
            },
          ),
          TodoCard(
            todoModel: TodoModel(
              id: 3,
              createdAt: DateTime.now(),
              todo: 'Dolor tempor minim officia duis est qui.',
              userId: '-1',
              isDone: true,
              priority: 1,
            ),
            onCheckedCallback: (bool val) {
              print('card 3 on check $val');
            },
          ),
        ],
      ),
    );
  }
}
