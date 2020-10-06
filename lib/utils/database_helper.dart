 import 'dart:io';

import 'package:notes/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper{

  static DatabaseHelper _databaseHelper; //singletone databaseHelper
  static Database _database;

  String noteTable='noteTable';
  String colId='id';
  String colTitle='title';
  String colDescription='description';
  String colPriority='priority';
  String colDate='date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){


    _databaseHelper=DatabaseHelper._createInstance();

    return _databaseHelper;
  }

  Future<Database> get database async{

    if(_database==null){
     _database=await initializedDatabase();
    }
    return _database;

  }

  Future<Database> initializedDatabase() async{

    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path+"notes.db";

    var noteDatabase=await openDatabase(path,version: 1,onCreate: _createDb);

    return noteDatabase;
  }

  void _createDb(Database db,int newVersion) async {

    await db.execute("CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colTitle TEXT,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)");


  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database db=await this.database;
    // var result=await db.rawQuery("SELECT * FROM $noteTable order by $colPriority ASC");
    var result=await db.query(noteTable,orderBy:'$colPriority ASC' );
    return result;
  }

  Future<int> insertNote(Note note) async{
    Database db=await this.database;
    var result=await db.insert(noteTable,note.toMap());
    return result;
  }
  Future<int> updateNote(Note note) async{
    Database db=await this.database;
    var result=await db.update(noteTable,note.toMap(),where: '$colId=?',whereArgs: [note.id]);
    return result;
  }
  Future<int> deleteNote(int id) async{
    Database db=await this.database;
    var result=await db.rawDelete("DELETE FROM $noteTable WHERE $colId= $id");
    return result;
  }
  Future<int> getCount() async{

    Database db=await this.database;
    List<Map<String, dynamic>> x=await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    int result=Sqflite.firstIntValue(x);
    return result;

  }

  Future<List<Note>> getNoteList() async {

    var noteMapList=await getNoteMapList();
    int count=noteMapList.length;
    List<Note> noteList=List<Note>();
    for(int i=0;i<count;i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;

  }

 }