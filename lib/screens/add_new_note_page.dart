import 'package:flutter/material.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/constants/icons/notes_icons.dart';
import 'package:notes_app/widgets/cutom_dailog.dart';
import 'package:notes_app/utils/size_config.dart';

import '../constants/constants.dart';
import '../widgets/notes_button.dart';

class AddNewNote extends StatefulWidget {
  @override
  _AddNewNoteState createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  TextEditingController _noteHeadingController;
  TextEditingController _noteBodyController;

  @override
  void initState() {
    _noteHeadingController = TextEditingController();
    _noteBodyController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroungColor,
      floatingActionButton: (_noteHeadingController.text.isNotEmpty &&
              _noteBodyController.text.isNotEmpty)
          ? FloatingActionButton.extended(
              onPressed: () => null,
              backgroundColor: kButtonColor,
              elevation: 20,
              icon: Icon(NotesIcons.noteSave, size: 18),
              label: Text('Save'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(22))),
            )
          : null,
      body: DefaultTextStyle(
          style: kNotesDefaultTextStyle,
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.toWidth),
            child: ListView(
              children: [
                SizedBox(height: 10.toHeight),
                Container(
                  alignment: Alignment.topLeft,
                  child: NotesButton(
                      onTap: () {
                        if (_noteBodyController.text.isNotEmpty &&
                            _noteHeadingController.text.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                    title:
                                        "Going back will discard this note, are you sure you want to go back ?",
                                    onTapNegetive: () {
                                      Navigator.of(context).pop();
                                    },
                                    onTapPositive: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    });
                              });
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(NotesIcons.noteBack,
                          color: kTextColor, size: 18.toFont)),
                ),
                SizedBox(height: 10.toHeight),
                TextField(
                  onChanged: (value) => setState(() {}),
                  maxLines: null,
                  style: kNotesDefaultHeadingStyle.copyWith(
                      fontSize: 30, color: kTextColor),
                  controller: _noteHeadingController,
                  cursorColor: kTextColor,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: kNotesDefaultHeadingStyle.copyWith(
                          fontSize: 30, color: kTextColor.withOpacity(0.6))),
                ),
                SizedBox(height: 20.toHeight),
                TextField(
                  maxLines: null,
                  onChanged: (value) => setState(() {}),
                  style: kNotesDefaultHeadingStyle.copyWith(
                      fontSize: 20, color: kTextColor),
                  controller: _noteBodyController,
                  cursorColor: kTextColor,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Type something ...',
                      hintStyle: kNotesDefaultHeadingStyle.copyWith(
                          fontSize: 20, color: kTextColor.withOpacity(0.6))),
                ),
              ],
            ),
          ))),
    );
  }
}
