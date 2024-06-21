import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'equipo.dart';

class EquipoDatabase {
  static final EquipoDatabase instance = EquipoDatabase._internal();

  static Database? _database;

  EquipoDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'equipos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${EquipoFields.tableName} (
          ${EquipoFields.id} ${EquipoFields.idType},
          ${EquipoFields.name} ${EquipoFields.textType},
          ${EquipoFields.foundingYear} ${EquipoFields.intType},
          ${EquipoFields.lastChampionshipDate} ${EquipoFields.dateType}
        )
      ''');
  }

  Future<Equipo> create(Equipo equipo) async {
    final db = await instance.database;
    final id = await db.insert(EquipoFields.tableName, equipo.toJson());
    return equipo.copy(id: id);
  }

  Future<Equipo> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      EquipoFields.tableName,
      columns: EquipoFields.values,
      where: '${EquipoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Equipo.fromJson(maps.first);
    } else {
      throw Exception('Equipo with ID $id not found');
    }
  }

  Future<List<Equipo>> readAll() async {
    final db = await instance.database;
    final result = await db.query(EquipoFields.tableName);
    return result.map((json) => Equipo.fromJson(json)).toList();
  }

  Future<int> update(Equipo equipo) async {
    final db = await instance.database;
    return db.update(
      EquipoFields.tableName,
      equipo.toJson(),
      where: '${EquipoFields.id} = ?',
      whereArgs: [equipo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      EquipoFields.tableName,
      where: '${EquipoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
