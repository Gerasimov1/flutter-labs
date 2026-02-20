import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT UNIQUE NOT NULL,
        year TEXT,
        genre TEXT,
        poster TEXT,
        plot TEXT,
        imdbId TEXT,
        director TEXT,
        actors TEXT,
        rating TEXT
      )
    ''');
    await db.execute('CREATE INDEX idx_favorites_title ON favorites(title)');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Миграции для будущих версий
    }
  }

  Future<int> insertFavorite(Movie movie) async {
    final db = await instance.database;
    return await db.insert(
      'favorites', 
      movie.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Movie>> getFavorites() async {
    final db = await instance.database;
    final result = await db.query('favorites', orderBy: 'title ASC');
    return result.map((json) => Movie.fromMap(json)).toList();
  }

  Future<int> deleteFavorite(String title) async {
    final db = await instance.database;

    return await db.delete(
      'favorites',
      where: 'TRIM(title) = TRIM(?)',
      whereArgs: [title],
    );
  }

  Future<bool> isFavorite(String title) async {
    final db = await instance.database;

    final result = await db.query(
      'favorites',
      where: 'TRIM(title) = TRIM(?)',
      whereArgs: [title],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}