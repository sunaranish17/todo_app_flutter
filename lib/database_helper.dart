import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
        await db.execute(
          'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)',
        );
        // return db;
      },
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    Database _db = await database();
    await _db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertToDo(ToDo todo) async {
    Database _db = await database();
    await _db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTask() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(
      taskMap.length,
      (index) => Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']),
    );
  }

  Future<List<ToDo>> getToDo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> toDoMap =
        await _db.rawQuery("SELECT * FROM todo where taskId = $taskId");
    return List.generate(
      toDoMap.length,
      (index) => ToDo(
          id: toDoMap[index]['id'],
          title: toDoMap[index]['title'],
          taskId: toDoMap[index]['taskId'],
          isDone: toDoMap[index]['isDone']),
    );
  }
}
