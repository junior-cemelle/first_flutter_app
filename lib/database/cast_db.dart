import 'dart:io';

import 'package:dmsn2026/models/cast_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CastDB {

  static final nameDB = "CASTDB";
  static final versionDB = 1;

  static Database? _database;
  
  Future<Database?> get database async {
    if (_database != null) return _database;
    
    return _database = await _initDatabase();
  }
  
  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join (folder.path , nameDB);
    return openDatabase(
      pathDB,
      version: versionDB,
      onCreate: createTables
    );
  }

  createTables(Database db, int version) {
    String query = ''' 
      CREATE TABLE tblCast (
        idCast INTEGER PRIMARY KEY AUTOINCREMENT,
        nameCast VARCHAR(50),
        bitrhCast CHAR(10),
        genderCast CHAR(1)
      )
    ''';
    db.execute(query);
  }

  Future<int> insert(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert('tblCast', data);
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    var conexion = await database;
    return conexion!.update('tblCast', data, where: 'idCast = ?', whereArgs: [id]);
  }

  Future<int> delete (int idCast) async {
    var conexion = await database;
    return conexion!.delete('tblCast', where: 'idCast = ?', whereArgs: [idCast]);
  }

  Future<List<CastDAO>> selectAll() async {
    var conexion = await database;
    var result = await conexion!.query('tblCast');
    return result.map((cast) => CastDAO.fromMap(cast)).toList();
  }

  Future<CastDAO?> selectOne(int idCast) async {
    var conexion = await database;
    var result = await conexion!.query('tblCast', where: 'idCast = ?', whereArgs: [idCast]);
    if (result.isNotEmpty) {
      return CastDAO.fromMap(result.first);
    }
    return null;
  }
}