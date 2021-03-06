import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/constants/icons/notes_icons.dart';
import 'package:notes_app/model/notes.dart';
import 'package:notes_app/provider/notes_model.dart';
import 'package:notes_app/widgets/custom_dailog.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/gradient_list.dart';
import 'package:notes_app/widgets/remove_glow.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../constants/constants.dart';
import '../widgets/notes_button.dart';

class AddNewNote extends StatefulWidget {
  @override
  _AddNewNoteState createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  TextEditingController _noteHeadingController;
  TextEditingController _noteBodyController;
  Uuid _uniqueId;

  @override
  void initState() {
    _uniqueId = Uuid();
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
              onPressed: () {
                HapticFeedback.lightImpact();
                var newNote = Note(
                    _uniqueId.v1(),
                    DateTime.now().toString(),
                    DateTime.now().toString(),
                    _noteHeadingController.text,
                    _noteBodyController.text,
                    false);
                Provider.of<NotesModel>(context, listen: false)
                    .addNote(newNote);
                Navigator.of(context).pop();
              },
              backgroundColor: kButtonColor,
              elevation: 20,
              icon: Icon(NotesIcons.noteSave, size: 18.toFont),
              label: Text('Save'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(22))),
            )
          : null,
      body: DefaultTextStyle(
          style: kNotesDefaultTextStyle,
          child: SafeArea(
              bottom: false,
              child: GradientList(
                backgroundColor: kBackgroungColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.toWidth),
                  child: ScrollConfiguration(
                    behavior: RemoveGlowBehavior(),
                    child: ListView(
                      children: [
                        SizedBox(height: 20.toHeight),
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
                                                "Going back will discard this memo, are you sure you want to go back ?",
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
                          autofocus: true,
                          onChanged: (value) => setState(() {}),
                          maxLines: null,
                          style: kNotesDefaultHeadingStyle.copyWith(
                              fontSize: 30, color: kTextColor),
                          controller: _noteHeadingController,
                          cursorColor: kTextColor,
                          decoration: InputDecoration(
                              border: kNoInputBorder,
                              focusedBorder: kNoInputBorder,
                              enabledBorder: kNoInputBorder,
                              errorBorder: kNoInputBorder,
                              disabledBorder: kNoInputBorder,
                              hintText: 'Title',
                              hintStyle: kNotesDefaultHeadingStyle.copyWith(
                                  fontSize: 30.toFont,
                                  color: kTextColor.withOpacity(0.6))),
                        ),
                        SizedBox(height: 20.toHeight),
                        TextField(
                          maxLines: null,
                          onChanged: (value) => setState(() {}),
                          style: kNotesDefaultHeadingStyle.copyWith(
                              fontSize: 20.toFont, color: kTextColor),
                          controller: _noteBodyController,
                          cursorColor: kTextColor,
                          decoration: InputDecoration(
                              border: kNoInputBorder,
                              focusedBorder: kNoInputBorder,
                              enabledBorder: kNoInputBorder,
                              errorBorder: kNoInputBorder,
                              disabledBorder: kNoInputBorder,
                              hintText: 'Type something ...',
                              hintStyle: kNotesDefaultHeadingStyle.copyWith(
                                  fontSize: 20.toFont,
                                  color: kTextColor.withOpacity(0.6))),
                        ),
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _noteHeadingController.dispose();
    _noteBodyController.dispose();
  }
}
