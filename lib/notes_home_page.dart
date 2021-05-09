import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:notes_app/add_new_note_page.dart';
import 'package:notes_app/constants/constants.dart';
import 'package:notes_app/constants/icons/notes_icons.dart';
import 'package:notes_app/cutom_dailog.dart';
import 'package:notes_app/hive_db.dart';
import 'package:notes_app/notes_button.dart';
import 'package:notes_app/notes_open_page.dart';
import 'package:notes_app/utils/helpers.dart';
import 'package:notes_app/no_notes_available.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:uuid/uuid.dart';
import 'constants/constant_colors.dart';

class NotesHomePage extends StatefulWidget {
  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  HiveDataProvider _hiveDataProvider;
  Uuid _uniqueId;
  ScrollController _scrollController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  bool notesAvailable = false;

  @override
  void initState() {
    _hiveDataProvider = HiveDataProvider();
    _uniqueId = Uuid();
    _scrollController = ScrollController();
    _scrollController = new ScrollController();
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
      backgroundColor: kBackgroungColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => AddNewNote())),
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
                child: Column(
                  children: [
                    AnimatedContainer(
                      height: _showAppbar ? 60.toHeight : 0,
                      duration: Duration(milliseconds: 200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Notes',
                              style: kNotesDefaultHeadingStyle.copyWith(
                                  fontSize: 34)),
                          NotesButton(
                              onTap: () => null,
                              icon: _showAppbar
                                  ? Icon(NotesIcons.noteSearch,
                                      color: kTextColor, size: 18.toFont)
                                  : null),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.toHeight),
                    (notesAvailable)
                        ? NoNotesAvailable()
                        : Expanded(
                            child: StaggeredGridView.count(
                              controller: _scrollController,
                              crossAxisCount: 4,
                              staggeredTiles: List.generate(
                                  15, (index) => getTileShape(index)),
                              mainAxisSpacing: 12.toHeight,
                              crossAxisSpacing: 12.toWidth,
                              children: List.generate(
                                  15,
                                  (index) => FocusedMenuHolder(
                                        onPressed: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        NotesOpenPage())),
                                        menuItems: <FocusedMenuItem>[
                                          FocusedMenuItem(
                                              backgroundColor: kBackgroungColor
                                                  .withOpacity(0.8),
                                              title: Text("Edit",
                                                  style:
                                                      kNotesDefaultTextStyle),
                                              trailingIcon: Icon(
                                                NotesIcons.noteEdit,
                                                color: kTextColor,
                                              ),
                                              onPressed: () => Navigator.of(
                                                      context)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          NotesOpenPage()))),
                                          FocusedMenuItem(
                                              backgroundColor: kBackgroungColor
                                                  .withOpacity(0.8),
                                              title: Text("Share",
                                                  style:
                                                      kNotesDefaultTextStyle),
                                              trailingIcon: Icon(
                                                NotesIcons.noteShare,
                                                color: kTextColor,
                                              ),
                                              onPressed: () {}),
                                          FocusedMenuItem(
                                              backgroundColor: kBackgroungColor
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
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                          title:
                                                              "Are you sure you want to delete this note ?",
                                                          onTapNegetive: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          onTapPositive: () {
                                                            print('Deleted !!');
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                    });
                                              }),
                                        ],
                                        blurSize: 4,
                                        menuBoxDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color:
                                              kBackgroungColor.withOpacity(0.8),
                                        ),
                                        menuItemExtent: 50.toHeight,
                                        duration: Duration(milliseconds: 400),
                                        menuOffset: 10.toHeight,
                                        animateMenuItems: false,
                                        menuWidth: SizeConfig().screenWidth / 2,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: getColor(index),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)))),
                                      )),
                            ),
                          )
                  ],
                ),
              ))),
    );
  }
}
