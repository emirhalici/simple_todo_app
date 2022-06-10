import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_todo_app/models/todo_model.dart';
import 'package:simple_todo_app/project_utils.dart';

class AddTodoSheet extends StatefulWidget {
  final Future<bool> Function(TodoModel todoModel) addTodoCallback;
  const AddTodoSheet({super.key, required this.addTodoCallback});

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  void showSnackBarMessage(String message) => ProjectUtils.showSnackBarMessage(context, message);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController todoController = TextEditingController();
  int _priorityValue = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'Add Todo',
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: todoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                hintText: 'Enter todo',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            Text(
              'Priority',
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
            Text(
              'from highest to lowest',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Center(
              child: NumberPicker(
                  minValue: 1,
                  maxValue: 3,
                  axis: Axis.horizontal,
                  haptics: true,
                  //itemHeight: 50,
                  //itemWidth: 100,
                  value: _priorityValue,
                  selectedTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 26.sp,
                  ),
                  onChanged: (int val) {
                    setState(() {
                      _priorityValue = val;
                    });
                  }),
            ),
            SizedBox(height: 32.h),
            if (_isLoading) ProjectUtils.circularProgressBar(context),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String todoText = todoController.text;
                    int todoPriority = _priorityValue;

                    TodoModel model = TodoModel(
                      id: -1,
                      createdAt: DateTime.now(),
                      todo: todoText,
                      userId: 'ASD',
                      isDone: false,
                      priority: todoPriority,
                    );

                    setState(() {
                      _isLoading = true;
                    });
                    bool result = await widget.addTodoCallback(model);
                    if (!result) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
