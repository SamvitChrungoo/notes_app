import 'package:flutter/material.dart';
import 'package:notes_app/model/notes.dart';
import 'package:notes_app/utils/hive_db.dart';

class NotesModel with ChangeNotifier {
  List<dynamic> notes;
  bool notesAvailable = false;
  String modelError;

  void getAllNotes() async {
    var fetchedNotes = await HiveDataProvider.instance.readData('mynotes');
    if (fetchedNotes.isNotEmpty) {
      notes = fetchedNotes;
      notesAvailable = true;
      sortNotes();
    }
    notifyListeners();
  }

  void deleteNote(String id) async {
    await HiveDataProvider.instance
        .deleteData('mynotes', id)
        .catchError((error) {
      modelError = error;
    });
    if (modelError == null || modelError.isEmpty) {
      notes.removeWhere((element) => element.id == id);
      if (notes.isEmpty) {
        notesAvailable = false;
      }
      sortNotes();
    }
    notifyListeners();
  }

  void addNote(Note newNote) async {
    await HiveDataProvider.instance
        .insertData('mynotes', newNote)
        .catchError((error) {
      modelError = error;
    });
    if (modelError == null || modelError.isEmpty) {
      if (notes == null || notes.isEmpty) {
        notesAvailable = true;
        notes = [];
      }
      notes.add(newNote);
      sortNotes();
    }
    notifyListeners();
  }

  void updateNote(Note updatedNote) async {
    await HiveDataProvider.instance
        .updateData('mynotes', updatedNote)
        .catchError((error) {
      modelError = error;
    });
    if (modelError == null || modelError.isEmpty) {
      notes[notes.indexWhere((element) => element.id == updatedNote.id)] =
          updatedNote;
    }
    sortNotes();
    notifyListeners();
  }

  List<dynamic> searchNotes(String query) {
    var results = [];
    notes.forEach((element) {
      if (element.title.toString().toLowerCase().contains(query.toLowerCase()))
        results.add(element);
    });
    return results;
  }

  void sortNotes() {
    notes.sort((a, b) => DateTime.tryParse(b.updatedAt)
        .compareTo(DateTime.tryParse(a.updatedAt)));
    notes.sort((a, b) => b.starred.toString().compareTo(a.starred.toString()));
  }
}
