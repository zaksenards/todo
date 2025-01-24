import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/todo_model.dart';

/**
 * Handles persistence data operations
 */

class Persistence extends ChangeNotifier {
  static final Persistence _singleton = Persistence._internal();
  List<TodoModel> todos = [];
  Database? _db;

  Persistence._internal();
  factory Persistence() {
    return _singleton;
  }

  void onDatabaseUpgrade(db, oldVersion, newVersion) {
    db.execute("ALTER TABLE todo RENAME TO todo_old");
    onDatabaseCreateV2(db, newVersion);
    db.execute(
      "INSERT INTO todo (id, title, description, done) SELECT id, title, description, done FROM todo_old",
    );
    db.execute("DROP TABLE todo_old");
  }

  void onDatabaseCreateV1(db, version) {
    /**
       * @brief: Creates a table to store the user's todo data
       * 
       * @id: Todo's unique identifier.
       * 
       * @title: Todo's title
       * 
       * @description: Todo's description
       * 
       * @done: Todo's status
       * 
       */
    db.execute(
      '''CREATE TABLE IF NOT EXISTS todo(
          id INTEGER PRIMARY KEY,
          title NVARCHAR NOT NULL,
          description NVARCHAR,
          done INTEGER NOT NULL,
          UNIQUE(id))''',
    );
  }

  void onDatabaseCreateV2(db, version) {
    /**
       * @brief: Creates a table to store the user's todo data
       * 
       * @id: Todo's unique identifier.
       * 
       * @title: Todo's title
       * 
       * @description: Todo's description
       * 
       * @body: Todo's body
       * 
       */
    db.execute(
      '''CREATE TABLE IF NOT EXISTS todo(
          id INTEGER PRIMARY KEY,
          title NVARCHAR NOT NULL,
          description NVARCHAR,
          body NVARCHAR,
          done INTEGER NOT NULL,
          UNIQUE(id))''',
    );
  }

  /**
   * Initializes the application database if nedded
   */
  Future<void> initialize() async {
    if (_db == null) {
      final String dbPath = await getDatabasesPath();
      _db = await openDatabase(
        join(dbPath, "todo.db"),
        onCreate: onDatabaseCreateV2,
        onUpgrade: onDatabaseUpgrade,
        version: 2,
      );
    }
    await _reloadTodos();
  }

  /**
   * 
   * @brief: Inserts a new row on 'todo' table
   * 
   * @title: Todo's title
   * 
   * @description: Todo's description
   * 
   */
  Future<void> insertRawTodo(
      {required String title,
      String? description,
      String? body,
      required bool done}) async {
    insertTodo(
      todo: TodoModel(
          title: title, description: description, body: body, done: done),
    );
  }

  /**
   * 
   * @bried: Updates existents 'TODO row'
   * 
   */
  Future<void> updateRawTodo(
      {required int id,
      required String title,
      String? description,
      String? body,
      required bool done}) async {
    _db!.update(
        'todo',
        TodoModel(
                id: id,
                title: title,
                description: description,
                body: body,
                done: done)
            .toJson(),
        where: 'id==?',
        whereArgs: [id]);

    await _reloadTodos();
    notifyListeners();
  }

  /**
   * 
   * @brief: Inserts a new row on 'todo' table
   * 
   * @todo: Model class containing all necessary informations
   * 
   */
  Future<void> insertTodo({required TodoModel todo}) async {
    _db!.insert(
      'todo',
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    await _reloadTodos();
    notifyListeners();
  }

  /**
   * 
   * @brief: Delete a todo from database
   * 
   * @todo: Model class containing all necessary informations
   * 
   */
  Future<void> deleteTodo({required TodoModel todo}) async {
    _db!.delete('todo', where: 'id=?', whereArgs: [todo.id]);
    await _reloadTodos();
    notifyListeners();
  }

  /**
   * 
   * @brief: Load/Reload all todo table's entrys
   * 
   * @todo: Model class containing all necessary informations
   * 
   */
  Future<void> _reloadTodos() async {
    todos.clear();
    List<Map<String, Object?>?> data = await _db!.query("todo");
    for (var el in data) {
      todos.add(TodoModel.fromJson(el));
    }
  }
}
