import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';

typedef OnSaveListenner = Function(int?, String, String, String, bool);

class TodoEditor extends StatefulWidget {
  const TodoEditor({super.key, required this.onSaveListenner, this.model});
  final OnSaveListenner onSaveListenner;
  final TodoModel? model;

  @override
  State<TodoEditor> createState() => _TodoEditorState();
}

class _TodoEditorState extends State<TodoEditor> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  bool done = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.model != null) {
      descriptionController.text = widget.model!.description ?? "";
      bodyController.text = widget.model!.body ?? "";
      titleController.text = widget.model!.title;
      done = widget.model!.done;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 30,
        left: 30.0,
        right: 30,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 30,
          children: [
            SizedBox(
              child: TextFormField(
                autocorrect: false,
                controller: titleController,
                decoration: InputDecoration(
                  suffixIcon: Checkbox(
                    value: done,
                    onChanged: (_) => setState(() {
                      done = !done;
                    }),
                  ),
                  label: Text("Title"),
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This filed musn't be empty";
                  }
                  return null;
                },
              ),
            ),
            TextField(
              autocorrect: false,
              controller: descriptionController,
              decoration: InputDecoration(
                label: Text("Description"),
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 200,
              child: TextField(
                controller: bodyController,
                maxLines: 20,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSaveListenner(widget.model?.id, titleController.text,
                      descriptionController.text, bodyController.text, done);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
