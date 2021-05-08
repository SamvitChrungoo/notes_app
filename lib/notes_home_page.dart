import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/constants/constants.dart';
import 'package:notes_app/constants/icons/notes_icons.dart';
import 'package:notes_app/hive_db.dart';
import 'package:notes_app/notes_button.dart';
import 'package:notes_app/notes_open_page.dart';
import 'package:notes_app/utils/helpers.dart';
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

  @override
  void initState() {
    _hiveDataProvider = HiveDataProvider();
    _uniqueId = Uuid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgroungColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NotesOpenPage())),
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
                    SizedBox(height: 10.toHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Notes',
                            style: kNotesDefaultHeadingStyle.copyWith(
                                fontSize: 34)),
                        NotesButton(
                            onTap: () => null,
                            icon: Icon(NotesIcons.noteSearch,
                                color: kTextColor, size: 18.toFont)),
                      ],
                    ),
                    SizedBox(height: 10.toHeight),
                    Expanded(
                      child: StaggeredGridView.count(
                        crossAxisCount: 4,
                        staggeredTiles:
                            List.generate(15, (index) => getTileShape(index)),
                        mainAxisSpacing: 13.toHeight,
                        crossAxisSpacing: 13.toWidth,
                        children: List.generate(
                            15,
                            (index) => Container(
                                decoration: BoxDecoration(
                                    color: getColor(index),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12))))),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}