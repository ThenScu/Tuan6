import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/SanPham.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qlsp.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sanpham (
        ma TEXT PRIMARY KEY,
        ten TEXT NOT NULL,
        gia REAL NOT NULL,
        giamGia REAL NOT NULL
      )
    ''');
  }

  Future<int> insert(SanPham sp) async {
    final db = await instance.database;
    return await db.insert('sanpham', sp.toMap());
  }

  Future<List<SanPham>> getAll() async {
    final db = await instance.database;
    final result = await db.query('sanpham');
    return result.map((json) => SanPham.fromMap(json)).toList();
  }
}