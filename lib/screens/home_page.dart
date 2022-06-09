import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_app/project_utils.dart';
import 'package:simple_todo_app/providers/main_provider.dart';
import 'package:simple_todo_app/widgets/todo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showSnackBarMessage(String message) => ProjectUtils.showSnackBarMessage(context, message);

  void getTodos() async {
    String responseMessage = await context.read<MainProvider>().getTodos();
    if (responseMessage != 'Success') {
      showSnackBarMessage('Error while getting todos from server.');
    }
  }

  @override
  void initState() {
    if (context.read<MainProvider>().mainTodos == null) {
      getTodos();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Todo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () async {
          // TODO : ADD NEW TODO
        },
      ),
      body: context.watch<MainProvider>().mainTodos == null
          ? ProjectUtils.circularProgressBar(context)
          : ListView.builder(
              itemCount: context.watch<MainProvider>().mainTodos?.length,
              itemBuilder: (context, index) => TodoCard(
                todoModel: context.watch<MainProvider>().mainTodos![index],
                onCheckedCallback: (bool val) {
                  // TODO : ADD ON CHECKED CALLBACK
                },
              ),
            ),
    );
  }
}
