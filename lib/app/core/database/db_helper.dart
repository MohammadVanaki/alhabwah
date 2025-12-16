import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DBHelper {
  static sqflite.Database? _db;
  // DatabaseFactory shared for all DB operations
  static late final sqflite.DatabaseFactory _dbFactory;

  static sqflite.DatabaseFactory get dbFactory => _dbFactory;

  static void initializeDatabaseFactory() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      _dbFactory = databaseFactoryFfi;
    } else {
      _dbFactory = sqflite.databaseFactory;
    }
  }

  /// Initialize and open the database, copy from assets if not exist
  static Future<sqflite.Database> initDb() async {
    if (_db != null) return _db!;

    // Get proper database directory path based on platform
    String dbPath;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbPath = await _dbFactory.getDatabasesPath();
    } else {
      dbPath = await sqflite.getDatabasesPath();
    }

    final dbDir = Directory(dbPath);
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }

    final path = join(dbPath, 'db.sqlite');

    // Copy database file from assets if it does not exist
    final exists = await File(path).exists();
    if (!exists) {
      final data = await rootBundle.load('assets/db/db.sqlite');
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // Open database
    _db = await _dbFactory.openDatabase(path);
    return _db!;
  }

  static Future<void> closeDb() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      print('Database closed successfully.');
    } else {
      print('Database was already closed.');
    }
  }

  /// Execute a simple query on the given table
  static Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await initDb();
    return db.query(table);
  }

  /// Get book groups
  static Future<List<Map<String, dynamic>>> getBookGroups() async {
    final db = await initDb();
    return await db.query('bookgroups');
  }

  /// Get book info by bookId
  static Future<Map<String, dynamic>?> getBookInfo() async {
    final db = await initDb();
    final result = await db.query('books', where: 'id = ?');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  /// Run raw SQL query
  static Future<List<Map<String, dynamic>>> rawQuery(String sql) async {
    final db = await initDb();
    return db.rawQuery(sql);
  }
}
