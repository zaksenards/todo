import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';

typedef OnClickListenner = Function(TodoModel model);
typedef OnPressListenner = Function(TodoModel model);

class TodoViewer extends StatelessWidget {
  const TodoViewer(
      {super.key,
      required this.todo,
      required this.onClick,
      required this.onPress});
  final OnClickListenner onClick;
  final OnPressListenner onPress;
  final TodoModel todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        onPressed: () => onClick(todo),
        onLongPress: () => onPress(todo),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(
              todo.done
                  ? Icons.task_alt_outlined
                  : Icons.radio_button_unchecked,
              size: 28,
              color: todo.done ? Colors.green.shade200 : Colors.red.shade200,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                    overflow: TextOverflow.clip,
                  ),
                  todo.description != null
                      ? Text(
                          todo.description ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
