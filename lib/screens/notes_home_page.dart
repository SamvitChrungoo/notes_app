import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/model/notes.dart';
import 'package:notes_app/provider/notes_model.dart';
import 'package:notes_app/screens/add_new_note_page.dart';
import 'package:notes_app/constants/constants.dart';
import 'package:notes_app/constants/icons/notes_icons.dart';
import 'package:notes_app/screens/search_page.dart';
import 'package:notes_app/widgets/custom_dailog.dart';
import 'package:notes_app/widgets/notes_button.dart';
import 'package:notes_app/screens/notes_open_page.dart';
import 'package:notes_app/utils/helpers.dart';
import 'package:notes_app/widgets/no_notes_available.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/remove_glow.dart';
import 'package:provider/provider.dart';
import '../constants/constant_colors.dart';

class NotesHomePage extends StatefulWidget {
  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  ScrollController _scrollController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroungColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          fToast.removeQueuedCustomToasts();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddNewNote()));
        },
        backgroundColor: kButtonColor,
        elevation: 20,
        child: Icon(Icons.add, size: 30.toFont),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
      ),
      body: DefaultTextStyle(
          style: kNotesDefaultTextStyle,
          child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.toWidth),
                child: Consumer<NotesModel>(
                  builder: (context, notesModel, child) {
                    return Column(
                      children: [
                        SizedBox(height: 10.toHeight),
                        AnimatedContainer(
                          height: _showAppbar ? 60.toHeight : 0,
                          duration: Duration(milliseconds: 200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('myMemo',
                                  style: kNotesDefaultHeadingStyle.copyWith(
                                      fontSize: 34)),
                              notesModel.notesAvailable
                                  ? NotesButton(
                                      onTap: () {
                                        fToast.removeQueuedCustomToasts();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        NotesSearchPage()));
                                      },
                                      icon: _showAppbar
                                          ? Icon(NotesIcons.noteSearch,
                                              color: kTextColor,
                                              size: 18.toFont)
                                          : null)
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.toHeight),
                        (!notesModel.notesAvailable)
                            ? NoNotesAvailable()
                            : Expanded(
                                child: ScrollConfiguration(
                                  behavior: RemoveGlowBehavior(),
                                  child: FadingEdgeScrollView.fromScrollView(
                                    gradientFractionOnEnd: 0.03,
                                    gradientFractionOnStart: 0.03,
                                    child: StaggeredGridView.count(
                                      controller: _scrollController,
                                      crossAxisCount: 4,
                                      staggeredTiles: List.generate(
                                          notesModel.notes.length,
                                          (index) => getTileShape(index)),
                                      mainAxisSpacing: 12.toHeight,
                                      crossAxisSpacing: 12.toWidth,
                                      children: List.generate(
                                          notesModel.notes.length,
                                          (index) => FocusedMenuHolder(
                                                onPressed: () {
                                                  fToast
                                                      .removeQueuedCustomToasts();

                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              NotesOpenPage(
                                                                  notesModel
                                                                          .notes[
                                                                      index])));
                                                },
                                                menuItems: <FocusedMenuItem>[
                                                  FocusedMenuItem(
                                                      backgroundColor:
                                                          kBackgroungColor
                                                              .withOpacity(0.8),
                                                      title: Text("Edit",
                                                          style:
                                                              kNotesDefaultTextStyle),
                                                      trailingIcon: Icon(
                                                        NotesIcons.noteEdit,
                                                        color: kTextColor,
                                                      ),
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        fToast
                                                            .removeQueuedCustomToasts();
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    NotesOpenPage(
                                                                      notesModel
                                                                              .notes[
                                                                          index],
                                                                      withEditing:
                                                                          true,
                                                                    )));
                                                      }),
                                                  FocusedMenuItem(
                                                      backgroundColor:
                                                          kBackgroungColor
                                                              .withOpacity(0.8),
                                                      title: Text("Share",
                                                          style:
                                                              kNotesDefaultTextStyle),
                                                      trailingIcon: Icon(
                                                        NotesIcons.noteShare,
                                                        color: kTextColor,
                                                      ),
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        shareNote(
                                                            '${notesModel.notes[index].title}\n${notesModel.notes[index].content}');
                                                      }),
                                                  FocusedMenuItem(
                                                      backgroundColor:
                                                          kBackgroungColor
                                                              .withOpacity(0.8),
                                                      title: Text("Delete",
                                                          style: kNotesDefaultTextStyle
                                                              .copyWith(
                                                                  color: Colors
                                                                      .redAccent)),
                                                      trailingIcon: Icon(
                                                        NotesIcons.noteDelete,
                                                        color: Colors.redAccent,
                                                      ),
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CustomDialogBox(
                                                                  title:
                                                                      kDeleteConfirmationText,
                                                                  onTapNegetive:
                                                                      () {
                                                                    fToast
                                                                        .removeQueuedCustomToasts();

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  onTapPositive:
                                                                      () {
                                                                    fToast
                                                                        .removeQueuedCustomToasts();
                                                                    Provider.of<NotesModel>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .deleteNote(notesModel
                                                                            .notes[index]
                                                                            .id);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  });
                                                            });
                                                      }),
                                                ],
                                                blurSize: 4,
                                                menuBoxDecoration:
                                                    BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: kBackgroungColor
                                                      .withOpacity(0.8),
                                                ),
                                                menuItemExtent: 50.toHeight,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                menuOffset: 10.toHeight,
                                                animateMenuItems: false,
                                                menuWidth:
                                                    SizeConfig().screenWidth /
                                                        2,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10.toWidth,
                                                      right: 10.toWidth,
                                                      top: 12.toHeight),
                                                  decoration: BoxDecoration(
                                                      color: getColor(index),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          notesModel
                                                              .notes[index]
                                                              .title
                                                              .toString(),
                                                          style: kNotesDefaultTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kBackgroungColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  letterSpacing:
                                                                      0.2,
                                                                  height: 1.2,
                                                                  fontSize: index %
                                                                              7 ==
                                                                          2
                                                                      ? 25
                                                                          .toFont
                                                                      : (index % 7 == 3 ||
                                                                              index % 7 ==
                                                                                  5)
                                                                          ? 23
                                                                              .toFont
                                                                          : 20.5
                                                                              .toFont),
                                                          maxLines: (index %
                                                                          7 ==
                                                                      3 ||
                                                                  index % 7 ==
                                                                      5)
                                                              ? 6
                                                              : index % 7 == 2
                                                                  ? 3
                                                                  : 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: 10.toHeight),
                                                      Container(
                                                        child: Expanded(
                                                            child: ShaderMask(
                                                          blendMode:
                                                              BlendMode.dstIn,
                                                          shaderCallback:
                                                              (rect) {
                                                            return LinearGradient(
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              stops: [
                                                                0.2,
                                                                0.6,
                                                                1.0
                                                              ],
                                                              colors: [
                                                                Colors.black,
                                                                Colors.black,
                                                                Colors
                                                                    .transparent,
                                                              ],
                                                            ).createShader(
                                                              Rect.fromLTRB(
                                                                  0,
                                                                  0,
                                                                  rect.width,
                                                                  rect.height),
                                                            );
                                                          },
                                                          child: Text(
                                                              notesModel
                                                                  .notes[index]
                                                                  .content,
                                                              style: kNotesDefaultTextStyle.copyWith(
                                                                  color:
                                                                      kBackgroungColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.2,
                                                                  fontSize:
                                                                      18)),
                                                        )),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10
                                                                    .toHeight),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                HapticFeedback
                                                                    .lightImpact();
                                                                Note
                                                                    updatedNote =
                                                                    notesModel.notes[
                                                                            index]
                                                                        as Note;
                                                                notesModel.updateNote(updatedNote.copyWith(
                                                                    starred: !notesModel
                                                                        .notes[
                                                                            index]
                                                                        .starred));
                                                                fToast
                                                                    .showToast(
                                                                  child: Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(25.0),
                                                                        color: kButtonColor
                                                                            .withOpacity(0.8),
                                                                      ),
                                                                      child: Text(
                                                                        notesModel.notes[index].starred
                                                                            ? "Removed from starred"
                                                                            : "Added to starred",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              kTextColor,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      )),
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  toastDuration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                );
                                                              },
                                                              child: Icon(
                                                                  notesModel
                                                                          .notes[
                                                                              index]
                                                                          .starred
                                                                      ? NotesIcons
                                                                          .noteStarFilled
                                                                      : NotesIcons
                                                                          .noteStarHollow,
                                                                  color:
                                                                      kButtonColor,
                                                                  size: 18
                                                                      .toFont),
                                                            ),
                                                            Text(
                                                                DateFormat(
                                                                        'MMMM d, y')
                                                                    .format(DateTime.tryParse(notesModel
                                                                        .notes[
                                                                            index]
                                                                        .updatedAt)),
                                                                style: kNotesDefaultTextStyle.copyWith(
                                                                    color: kButtonColor
                                                                        .withOpacity(
                                                                            0.6))),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ))),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }
}
