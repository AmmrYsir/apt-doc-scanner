import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('documents.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        imagePaths TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isSynced INTEGER NOT NULL,
        googleDriveId TEXT,
        iCloudId TEXT
      )
    ''');
  }

  Future<int> insertDocument(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(
      'documents',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllDocuments() async {
    final db = await instance.database;
    return await db.query('documents', orderBy: 'createdAt DESC');
  }

  Future<int> deleteDocument(String id) async {
    final db = await instance.database;
    return await db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateDocument(Map<String, dynamic> row) async {
    final db = await instance.database;
    final id = row['id'];
    return await db.update('documents', row, where: 'id = ?', whereArgs: [id]);
  }
}
