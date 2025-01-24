class TodoModel {
  int? id;
  String title;
  String? description;
  bool done;

  TodoModel(
      {this.id, required this.title, this.description, required this.done});

  /**
   * 
   * @bried: Return current data on json format
   * 
   */
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'done': done ? 1 : 0
    };
  }

  static TodoModel fromJson(Map<String, Object?>? data) {
    return TodoModel(
      id: data!['id'] as int?,
      title: data['title'] as String,
      description: data['description'] as String?,
      done: data['done'] == 1 ? true : false,
    );
  }
}
