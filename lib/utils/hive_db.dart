import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/model/notes.dart';

class HiveDataProvider {
  bool _initialized = false;

  HiveDataProvider._databaseInit();
  static final HiveDataProvider _instance = HiveDataProvider._databaseInit();
  static HiveDataProvider get instance => _instance;

  Future<void> _databaseInit() async {
    if (!_initialized) {
      await Hive.initFlutter();
      Hive.registerAdapter(NoteAdapter());
      _initialized = true;
    }
  }

  Future<Box> _getBox<T>(String boxName) async {
    if (!_initialized) await _databaseInit();

    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    } else {
      return Hive.box<T>(boxName);
    }
  }

  Future<void> deleteData(String boxName, String id) async {
    var box = await _getBox(boxName);
    box.delete(id);
  }

  Future<void> insertData(String boxName, Note note) async {
    var box = await _getBox(boxName);
    box.put(note.id, note);
  }

  Future<List> readData(String boxName) async {
    var box = await _getBox(boxName);
    return box.values.toList();
  }

  Future<void> updateData(String boxName, String id, Note note) async {
    var box = await _getBox(boxName);
    box.put(id, note);
  }
}
