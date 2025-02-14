class Planet {
  final int id;
  final String name;
  final double distanceFromSun;
  final double size;
  final String? nickname;

  Planet({required this.id, required this.name, required this.distanceFromSun, required this.size, this.nickname});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'distanceFromSun': distanceFromSun,
      'size': size,
      'nickname': nickname,
    };
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'planet.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'planets.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE planets(id INTEGER PRIMARY KEY, name TEXT, distanceFromSun REAL, size REAL, nickname TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertPlanet(Planet planet) async {
    final db = await database;
    await db.insert('planets', planet.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Planet>> planets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('planets');
    return List.generate(maps.length, (i) {
      return Planet(
        id: maps[i]['id'],
        name: maps[i]['name'],
        distanceFromSun: maps[i]['distanceFromSun'],
        size: maps[i]['size'],
        nickname: maps[i]['nickname'],
      );
    });
  }

  Future<void> updatePlanet(Planet planet) async {
    final db = await database;
    await db.update(
      'planets',
      planet.toMap(),
      where: 'id = ?',
      whereArgs: [planet.id],
    );
  }

  Future<void> deletePlanet(int id) async 
}
