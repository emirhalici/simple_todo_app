import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_app/models/todo_model.dart';
import 'package:simple_todo_app/project_utils.dart';
import 'package:simple_todo_app/providers/main_provider.dart';
import 'package:simple_todo_app/widgets/add_todo_sheet.dart';
import 'package:simple_todo_app/widgets/edit_todo_sheet.dart';
import 'package:simple_todo_app/widgets/empty_state_widget.dart';
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
          showModalBottomSheet(
            context: context,
            builder: (context) => AddTodoSheet(
              addTodoCallback: ((todoModel) async {
                String response = await context.read<MainProvider>().addTodo(todoModel);
                if (response == 'Success' && mounted) {
                  Navigator.pop(context);
                  return true;
                } else {
                  showSnackBarMessage('Failed to add todo');
                  return false;
                }
              }),
            ),
          );
        },
      ),
      body: context.watch<MainProvider>().mainTodos == null
          ? ProjectUtils.circularProgressBar(context)
          : context.watch<MainProvider>().mainTodos!.isEmpty
              ? const EmptyStateWidget()
              : ListView.builder(
                  itemCount: context.watch<MainProvider>().mainTodos?.length,
                  itemBuilder: (context, index) => TodoCard(
                    todoModel: context.watch<MainProvider>().mainTodos![index],
                    onTappedCallback: (TodoModel todoModel) => showModalBottomSheet(
                      context: context,
                      builder: (context) => EditTodoSheet(
                        todoModel: TodoModel.copyFrom(context.read<MainProvider>().mainTodos![index]),
                      ),
                    ),
                    onCheckedCallback: (bool val) async {
                      TodoModel originalModel = context.read<MainProvider>().mainTodos![index];
                      TodoModel copy = TodoModel.copyFrom(originalModel);
                      copy.isDone = val;
                      context.read<MainProvider>().mainTodos![index] = copy;
                      try {
                        String response = await context.read<MainProvider>().editTodo(copy);
                        if (response != 'Success' && mounted) {
                          context.read<MainProvider>().mainTodos![index] = originalModel;
                          showSnackBarMessage('Error editing todo');
                        }
                      } catch (e) {
                        context.read<MainProvider>().mainTodos![index] = originalModel;
                        showSnackBarMessage('Error editing todo');
                      }
                    },
                  ),
                ),
    );
  }
}
