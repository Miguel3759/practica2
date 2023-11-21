import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';


class DatabaseHelper {
  static final _databaseName = "IngresosEgresos.db";
  static final _databaseVersion = 1;

  static final table = 'movimientos';

  static final columnId = '_id';
  static final columnTipo = 'tipo';
  static final columnMonto = 'monto';


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Crear la base de datos
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTipo TEXT NOT NULL,
            $columnMonto REAL NOT NULL
          )
          ''');
  }

  // Insertar movimiento
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // Obtener todos los movimientos
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  // Obtener el saldo actual
  Future<double> getSaldo() async {
    Database? db = await instance.database;
    var result = await db!.rawQuery(
        'SELECT SUM($columnMonto) as saldo FROM $table');
    return result.first['saldo'] as double;
  }
}