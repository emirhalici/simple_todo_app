import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_app/models/todo_model.dart';
import 'package:simple_todo_app/project_constants.dart';

class TodoCard extends StatefulWidget {
  final TodoModel todoModel;
  final Function onCheckedCallback;
  const TodoCard({super.key, required this.todoModel, required this.onCheckedCallback});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.todoModel.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color cardBackgroundColor = ProjectConstants.cardBackgroundColor(context);
    Color stripColor = ProjectConstants.priorityColor(widget.todoModel.priority);

    return SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 0,
          color: cardBackgroundColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          value: isChecked,
                          onChanged: (val) {
                            setState(() {
                              isChecked = val ?? false;
                              widget.onCheckedCallback(val);
                            });
                          },
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              widget.todoModel.todo,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            DateFormat('dd MMM yyyy').format(widget.todoModel.createdAt),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: stripColor,
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
