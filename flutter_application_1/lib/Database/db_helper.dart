import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../Model/SinhVien.dart';

class DatabaseHelper {
  // Dùng Singleton pattern để chỉ có 1 kết nối duy nhất
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sinhvien_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sinh_vien (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  // --- CÁC HÀM CRUD THEO YÊU CẦU CỦA ẢNH ---

  Future<List<SinhVien>> getSinhViens() async {
    final db = await instance.database;
    final result = await db.query('sinh_vien');
    return result.map((json) => SinhVien.fromMap(json)).toList();
  }

  Future<int> insertSinhVien(SinhVien sv) async {
    final db = await instance.database;
    return await db.insert('sinh_vien', sv.toMap());
  }

  Future<int> updateSinhVien(SinhVien sv) async {
    final db = await instance.database;
    return await db.update(
      'sinh_vien',
      sv.toMap(),
      where: 'id = ?',
      whereArgs: [sv.id],
    );
  }

  Future<int> deleteSinhVien(int id) async {
    final db = await instance.database;
    return await db.delete(
      'sinh_vien',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}