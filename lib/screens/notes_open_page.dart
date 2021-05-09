import 'package:flutter/material.dart';
import 'package:notes_app/constants/icons/notes_icons.dart';
import 'package:notes_app/widgets/cutom_dailog.dart';
import 'package:notes_app/widgets/notes_button.dart';
import 'package:notes_app/utils/size_config.dart';

import '../constants/constant_colors.dart';
import '../constants/constants.dart';

class NotesOpenPage extends StatefulWidget {
  @override
  _NotesOpenPageState createState() => _NotesOpenPageState();
}

class _NotesOpenPageState extends State<NotesOpenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroungColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => null,
        backgroundColor: kButtonColor,
        elevation: 20,
        icon: Icon(NotesIcons.noteSave, size: 18),
        label: Text('Save'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22))),
      ),
      body: DefaultTextStyle(
          style: kNotesDefaultTextStyle,
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.toWidth),
            child: Column(
              children: [
                SizedBox(height: 10.toHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NotesButton(
                        onTap: () => Navigator.of(context).pop(),
                        icon: Icon(NotesIcons.noteBack,
                            color: kTextColor, size: 18.toFont)),
                    Row(
                      children: [
                        NotesButton(
                            onTap: () => null,
                            icon: Icon(NotesIcons.noteShare,
                                color: kTextColor, size: 18.toFont)),
                        SizedBox(width: 10.toWidth),
                        NotesButton(
                            onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                      title:
                                          "Are you sure you want to delete this note ?",
                                      onTapNegetive: () =>
                                          Navigator.of(context).pop(),
                                      onTapPositive: () {
                                        print('Deleted !!');
                                        Navigator.of(context).pop();
                                      });
                                }),
                            icon: Icon(NotesIcons.noteDelete,
                                color: kTextColor, size: 18.toFont)),
                        SizedBox(width: 10.toWidth),
                        NotesButton(
                            onTap: () => null,
                            icon: Icon(NotesIcons.noteEdit,
                                color: kTextColor, size: 18.toFont)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ))),
    );
  }
}
