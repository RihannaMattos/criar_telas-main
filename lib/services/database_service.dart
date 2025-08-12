import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'users';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  static Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rm TEXT UNIQUE NOT NULL,
        senha TEXT NOT NULL
      )
    ''');
  }

  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<bool> registerUser(String rm, String senha) async {
    try {
      final db = await database;
      String hashedPassword = _hashPassword(senha);
      
      // Verifica se já existe antes de tentar inserir
      if (await userExists(rm)) {
        return false;
      }
      
      await db.insert(
        _tableName,
        {'rm': rm, 'senha': hashedPassword},
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return false;
    }
  }

  static Future<User?> loginUser(String rm, String senha) async {
    try {
      final db = await database;
      String hashedPassword = _hashPassword(senha);
      
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'rm = ? AND senha = ?',
        whereArgs: [rm, hashedPassword],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> userExists(String rm) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'rm = ?',
        whereArgs: [rm],
      );
      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}