import 'package:flutter/material.dart';
import 'package:notes_app/utils/hive_db.dart';

class NotesModel with ChangeNotifier {
  List<dynamic> notes;
  bool notesAvailable = false;

  void getNotes() async {
    var fetchedNotes = await HiveDataProvider.instance.readData('mynotes');
    print('hahaha ========= ${fetchedNotes.first}');
    if (fetchedNotes.isNotEmpty) {
      notes = fetchedNotes;
      notesAvailable = true;
    }
    print('nonoo ========= ${fetchedNotes.first.id}');
    notifyListeners();
  }
}
