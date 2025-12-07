import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/calculation_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cosmic_calculations.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE calculations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mass TEXT NOT NULL,
            radius TEXT NOT NULL,
            velocity_ms REAL NOT NULL,
            velocity_kms REAL NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertCalculation(CalculationModel calculation) async {
    final db = await database;
    return await db.insert('calculations', calculation.toMap());
  }

  Future<List<CalculationModel>> getAllCalculations() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'calculations',
        orderBy: 'created_at DESC',
      );
      
      return List.generate(maps.length, (i) {
        return CalculationModel.fromMap(maps[i]);
      });
    } catch (e) {
      print('Ошибка загрузки: $e');
      return [];
    }
  }

}