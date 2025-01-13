import 'package:todo/routes/home/widgets/todo_viewer.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/routes/home/widgets/todo_editor.dart';
import 'package:todo/utils/persistence.dart';
import 'package:flutter/material.dart';

class RouterHome extends StatefulWidget {
  const RouterHome({super.key, required this.appName});
  final String appName;

  @override
  State<RouterHome> createState() => _RouterHomeState();
}

class _RouterHomeState extends State<RouterHome> {
  final Persistence _instance = Persistence();
  List<TodoModel> todos = [];

  @override
  void initState() {
    super.initState();
    _instance.addListener(todoListenner);
    todos.addAll(_instance.todos);
  }

  void todoListenner() {
    todos.clear();
    setState(() {
      todos.addAll(_instance.todos);
    });
  }

  Future<void> onPressFAB(TodoModel? model) async {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: TodoEditor(
            onSaveListenner: onSaveListenner,
            model: model,
          ),
        );
      },
    );
  }

  Future<void> onSaveListenner(
      int? id, String title, String description, bool done) async {
    if (id != null) {
      await _instance.updateRawTodo(
          id: id, description: description, title: title, done: done);
      return;
    }

    await _instance.insertRawTodo(
        title: title, description: description, done: done);
  }

  void showDeletionDialog(TodoModel model) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete this album?"),
          content: Text("Are u sure?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                _instance.deleteTodo(todo: model);
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,      
      appBar: AppBar(
        elevation: 2,
        leading: Icon(Icons.tornado_rounded),
        title: Text(widget.appName),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) => TodoViewer(
          todo: todos[index],
          onClick: (model) => onPressFAB(model),
          onPress: (model) => showDeletionDialog(model),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: false,
        onPressed: () => onPressFAB(null),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
