import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_app/models/todo_model.dart';
import 'package:simple_todo_app/project_utils.dart';
import 'package:simple_todo_app/view_models/home_view_model.dart';
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
  void _showToast(BuildContext context, String message) => fToast.showToast(child: ProjectUtils.toastWidget(context, message));
  late FToast fToast;

  void getTodos() async {
    String responseMessage = await context.read<HomeViewModel>().getTodos();
    if (responseMessage != 'Success') {
      if (mounted) _showToast(context, 'Error while getting todos from server.');
    }
  }

  @override
  void initState() {
    if (context.read<HomeViewModel>().mainTodos == null) {
      getTodos();
    }
    fToast = FToast();
    fToast.init(context);
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
        onPressed: () async => showAddTodoModalBottomSheet(context),
      ),
      body: context.watch<HomeViewModel>().mainTodos == null
          ? buildLoadingState()
          : context.watch<HomeViewModel>().mainTodos!.isEmpty
              ? buildEmptyState()
              : buildListView(),
    );
  }

  showAddTodoModalBottomSheet(BuildContext context) async => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        builder: (context) => AddTodoSheet(
          addTodoCallback: ((todoModel) async {
            String response = await context.read<HomeViewModel>().addTodo(todoModel);
            if (response == 'Success' && mounted) {
              Navigator.pop(context);
              return true;
            } else {
              _showToast(context, 'Failed to add todo.');
              return false;
            }
          }),
        ),
      );

  Widget buildLoadingState() => ProjectUtils.circularProgressBar(context);

  Widget buildEmptyState() => const EmptyStateWidget();

  Widget buildListView() => ListView.builder(
        itemCount: context.watch<HomeViewModel>().mainTodos?.length,
        itemBuilder: (context, index) => TodoCard(
          todoModel: context.watch<HomeViewModel>().mainTodos![index],
          onTappedCallback: (TodoModel todoModel) => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            builder: (context) => EditTodoSheet(
              todoModel: TodoModel.copyFrom(context.read<HomeViewModel>().mainTodos![index]),
            ),
          ),
          onCheckedCallback: (bool val) async {
            await context.read<HomeViewModel>().todoCardOnCheckedCallback(val, index).then((response) {
              if (!response && mounted) {
                _showToast(context, 'Error editing todo.');
                return false;
              }
            });
            return true;
          },
        ),
      );
}
