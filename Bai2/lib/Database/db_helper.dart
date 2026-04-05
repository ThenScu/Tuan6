import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/Todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Tạo file database tên là todo_app.db
    _database = await _initDB('todo_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Khởi tạo bảng todos
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  // --- CÁC HÀM XỬ LÝ (CRUD) CHO TODO ---

  // 1. Lấy danh sách công việc
  Future<List<TodoItem>> getTodos() async {
    final db = await instance.database;
    final result = await db.query('todos');
    return result.map((json) => TodoItem.fromMap(json)).toList();
  }

  // 2. Thêm công việc mới
  Future<int> insertTodo(TodoItem todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo.toMap());
  }

  // 3. Cập nhật công việc (Sửa nội dung hoặc Check hoàn thành)
  Future<int> updateTodo(TodoItem todo) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // 4. Xóa công việc
  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}