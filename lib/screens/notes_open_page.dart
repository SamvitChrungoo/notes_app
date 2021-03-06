import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/constants/icons/notes_icons.dart';
import 'package:notes_app/model/notes.dart';
import 'package:notes_app/provider/notes_model.dart';
import 'package:notes_app/utils/helpers.dart';
import 'package:notes_app/widgets/custom_dailog.dart';
import 'package:notes_app/widgets/gradient_list.dart';
import 'package:notes_app/widgets/notes_button.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/remove_glow.dart';
import 'package:provider/provider.dart';

import '../constants/constant_colors.dart';
import '../constants/constants.dart';

class NotesOpenPage extends StatefulWidget {
  final Note currentNote;
  final bool withEditing;
  final bool fromSearch;
  final Function(bool) isDeleted;
  final Function(Note) isEdited;
  NotesOpenPage(
    this.currentNote, {
    this.withEditing = false,
    this.fromSearch = false,
    this.isDeleted,
    this.isEdited,
  });

  _NotesOpenPageState createState() => _NotesOpenPageState();
}

class _NotesOpenPageState extends State<NotesOpenPage> {
  TextEditingController _editHeadingController;
  TextEditingController _editContentController;
  bool startEditing = false;
  final FocusNode _titleTextFieldFocusNode = FocusNode();
  String initialHeading;
  String initialContent;

  @override
  void initState() {
    _editHeadingController =
        TextEditingController(text: widget.currentNote.title);
    _editContentController =
        TextEditingController(text: widget.currentNote.content);
    initialHeading = widget.currentNote.title;
    initialContent = widget.currentNote.content;
    checkEditing();
    super.initState();
  }

  void checkEditing() async {
    if (widget.withEditing) {
      setState(() {
        startEditing = true;
      });
      await Future.delayed(Duration(milliseconds: 500));
      _titleTextFieldFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroungColor,
      floatingActionButton: (_editHeadingController.text != initialHeading ||
              _editContentController.text != initialContent && startEditing)
          ? FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.lightImpact();
                var updatedNote = widget.currentNote.copyWith(
                    title: _editHeadingController.text,
                    content: _editContentController.text,
                    updatedAt: DateTime.now().toString());
                Provider.of<NotesModel>(context, listen: false)
                    .updateNote(updatedNote);
                if (widget.fromSearch) {
                  widget.isEdited(updatedNote);
                }
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
                                    onTap: () {
                                      shareNote(
                                          '${widget.currentNote.title}\n${widget.currentNote.content}');
                                    },
                                    icon: Icon(NotesIcons.noteShare,
                                        color: kTextColor, size: 18.toFont)),
                                SizedBox(width: 10.toWidth),
                                NotesButton(
                                    onTap: () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                              title: kDeleteConfirmationText,
                                              onTapNegetive: () =>
                                                  Navigator.of(context).pop(),
                                              onTapPositive: () {
                                                Provider.of<NotesModel>(context,
                                                        listen: false)
                                                    .deleteNote(
                                                        widget.currentNote.id);
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                if (widget.fromSearch) {
                                                  widget.isDeleted(true);
                                                }
                                              });
                                        }),
                                    icon: Icon(NotesIcons.noteDelete,
                                        color: kTextColor, size: 18.toFont)),
                                SizedBox(width: 10.toWidth),
                                startEditing
                                    ? SizedBox()
                                    : NotesButton(
                                        onTap: !startEditing
                                            ? () async {
                                                setState(() {
                                                  startEditing = true;
                                                });
                                                await Future.delayed(Duration(
                                                    milliseconds: 500));
                                                _titleTextFieldFocusNode
                                                    .requestFocus();
                                              }
                                            : () {},
                                        icon: Icon(NotesIcons.noteEdit,
                                            color: kTextColor,
                                            size: 18.toFont)),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20.toHeight),
                        Container(
                            child: TextField(
                          onChanged: (value) => setState(() {}),
                          focusNode: _titleTextFieldFocusNode,
                          maxLines: null,
                          enabled: startEditing,
                          style: kNotesDefaultHeadingStyle.copyWith(
                              fontSize: 30.toFont, color: kTextColor),
                          controller: _editHeadingController,
                          cursorColor: kTextColor,
                          decoration: InputDecoration(
                            border: kNoInputBorder,
                            focusedBorder: kNoInputBorder,
                            enabledBorder: kNoInputBorder,
                            errorBorder: kNoInputBorder,
                            disabledBorder: kNoInputBorder,
                          ),
                        )),
                        SizedBox(height: 10.toHeight),
                        !startEditing
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20.toHeight,
                                    child: Text(
                                        DateFormat('MMMM d, y').format(
                                            DateTime.tryParse(
                                                widget.currentNote.updatedAt)),
                                        style: kNotesDefaultTextStyle.copyWith(
                                            color:
                                                kTextColor.withOpacity(0.6))),
                                  ),
                                  SizedBox(height: 10.toHeight),
                                ],
                              )
                            : SizedBox(height: 30.toHeight),
                        Container(
                          child: TextField(
                            maxLines: null,
                            enabled: startEditing,
                            onChanged: (value) => setState(() {}),
                            style: kNotesDefaultHeadingStyle.copyWith(
                                fontSize: 20.toFont, color: kTextColor),
                            controller: _editContentController,
                            cursorColor: kTextColor,
                            decoration: InputDecoration(
                              border: kNoInputBorder,
                              focusedBorder: kNoInputBorder,
                              enabledBorder: kNoInputBorder,
                              errorBorder: kNoInputBorder,
                              disabledBorder: kNoInputBorder,
                            ),
                          ),
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
    _titleTextFieldFocusNode.dispose();
    _editHeadingController.dispose();
    _editContentController.dispose();
    super.dispose();
  }
}
