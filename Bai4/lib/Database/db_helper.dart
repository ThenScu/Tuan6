import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/ChiTieu.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_quan_ly.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Bảng Tài Khoản (Bài 5)
    await db.execute('''
      CREATE TABLE taikhoan (
        email TEXT PRIMARY KEY,
        pass TEXT NOT NULL
      )
    ''');

    // Tặng kèm tài khoản mặc định
    await db.rawInsert("INSERT INTO taikhoan (email, pass) VALUES ('admin', '123')");

    // Bảng Chi Tiêu
    await db.execute('''
      CREATE TABLE chitieu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        noidung TEXT NOT NULL,
        sotien REAL NOT NULL,
        ghichu TEXT
      )
    ''');
  }

  // --- HÀM TÀI KHOẢN ---
  Future<bool> checkLogin(String email, String pass) async {
    final db = await instance.database;
    final maps = await db.query('taikhoan', where: 'email = ? AND pass = ?', whereArgs: [email, pass]);
    return maps.isNotEmpty;
  }

  Future<bool> register(String email, String pass) async {
    final db = await instance.database;
    final maps = await db.query('taikhoan', where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) return false;
    await db.insert('taikhoan', {'email': email, 'pass': pass});
    return true;
  }

  // --- HÀM CHI TIÊU ---
  Future<int> insertChiTieu(ChiTieu ct) async {
    final db = await instance.database;
    return await db.insert('chitieu', {
      'noidung': ct.noiDung,
      'sotien': ct.soTien,
      'ghichu': ct.ghiChu
    });
  }

  Future<List<ChiTieu>> getAllChiTieu() async {
    final db = await instance.database;
    final result = await db.query('chitieu');
    return result.map((json) => ChiTieu(
      id: json['id'] as int,
      noiDung: json['noidung'] as String,
      soTien: json['sotien'] as double,
      ghiChu: json['ghichu'] as String,
    )).toList();
  }
}