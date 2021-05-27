import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/constants/constants.dart';
import 'package:notes_app/constants/icons/notes_icons.dart';
import 'package:notes_app/provider/notes_model.dart';
import 'package:notes_app/screens/notes_open_page.dart';
import 'package:notes_app/utils/helpers.dart';
import 'package:notes_app/widgets/custom_dailog.dart';
import 'package:notes_app/widgets/dynamic_highlight_text.dart';
import 'package:notes_app/widgets/notes_button.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/remove_glow.dart';
import 'package:provider/provider.dart';

class NotesSearchPage extends StatefulWidget {
  @override
  _NotesSearchPageState createState() => _NotesSearchPageState();
}

class _NotesSearchPageState extends State<NotesSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List searchResults = [];
  var resultOpacity = 0.0;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroungColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.toWidth),
          child: Consumer<NotesModel>(builder: (context, notesModel, child) {
            return Column(
              children: [
                SizedBox(height: 10.toHeight),
                Container(
                  height: 50.toHeight,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10.toHeight),
                        child: NotesButton(
                            onTap: () => Navigator.of(context).pop(),
                            icon: Icon(NotesIcons.noteBack,
                                color: kTextColor, size: 18.toFont)),
                      ),
                      SizedBox(width: 20.toWidth),
                      Expanded(
                          child: TextField(
                        controller: _searchController,
                        onChanged: (value) async {
                          setState(() {
                            searchResults = notesModel.searchNotes(value);
                          });
                          await Future.delayed(Duration(milliseconds: 200));
                          setState(() {
                            if (searchResults.isNotEmpty) {
                              resultOpacity = 1.0;
                            } else {
                              resultOpacity = 0.0;
                            }
                            if (_searchController.text.isEmpty) {
                              resultOpacity = 0.0;
                            }
                          });
                        },
                        autofocus: true,
                        style: kNotesDefaultHeadingStyle.copyWith(
                            fontSize: 22.toFont, color: kTextColor),
                        cursorColor: kTextColor,
                        decoration: InputDecoration(
                            border: kNoInputBorder,
                            focusedBorder: kNoInputBorder,
                            enabledBorder: kNoInputBorder,
                            errorBorder: kNoInputBorder,
                            disabledBorder: kNoInputBorder,
                            hintText: 'search memos ...',
                            hintStyle: kNotesDefaultHeadingStyle.copyWith(
                                fontSize: 20.toFont,
                                color: kTextColor.withOpacity(0.6))),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 16.toHeight),
                (searchResults.isEmpty || _searchController.text.isEmpty)
                    ? AnimatedSwitcher(
                        child: _searchController.text.isEmpty
                            ? Column(
                                key: Key(kStartSearchKey),
                                children: [
                                  SizedBox(
                                    height: 100.toHeight,
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Lottie.asset(
                                      kSearchMemoLottie,
                                      height: 200.toHeight,
                                    ),
                                  ),
                                  Text(kStartSearchingText,
                                      textAlign: TextAlign.center,
                                      style: kNotesDefaultHeadingStyle.copyWith(
                                          letterSpacing: 0.6,
                                          fontSize: 22.toFont,
                                          color: kTextColor.withOpacity(0.6)))
                                ],
                              )
                            : Column(
                                key: Key(kNoResultsFoundKey),
                                children: [
                                  SizedBox(
                                    height: 100.toHeight,
                                  ),
                                  SvgPicture.asset(
                                    kNoSearchResultsFound,
                                    color: kTextColor.withOpacity(0.4),
                                    height: 200.toHeight,
                                  ),
                                  SizedBox(height: 20.toHeight),
                                  Text(kNoSearchResultsFoundText,
                                      style: kNotesDefaultHeadingStyle.copyWith(
                                          letterSpacing: 0.6,
                                          fontSize: 22.toFont,
                                          color: kTextColor.withOpacity(0.6)))
                                ],
                              ),
                        duration: Duration(milliseconds: 500),
                      )
                    : Expanded(
                        child: AnimatedOpacity(
                          key: Key(kSearchResultKey),
                          opacity: resultOpacity,
                          duration: Duration(milliseconds: 500),
                          child: ScrollConfiguration(
                            behavior: RemoveGlowBehavior(),
                            child: FadingEdgeScrollView.fromScrollView(
                              gradientFractionOnEnd: 0.03,
                              gradientFractionOnStart: 0.03,
                              child: StaggeredGridView.count(
                                controller: _scrollController,
                                crossAxisCount: 4,
                                staggeredTiles: List.generate(
                                    searchResults.length,
                                    (index) => getTileShape(index)),
                                mainAxisSpacing: 12.toHeight,
                                crossAxisSpacing: 12.toWidth,
                                children: List.generate(
                                    searchResults.length,
                                    (index) => FocusedMenuHolder(
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      NotesOpenPage(
                                                        searchResults[index],
                                                        fromSearch: true,
                                                        isDeleted: (val) {
                                                          if (val) {
                                                            searchResults
                                                                .removeAt(
                                                                    index);
                                                          }
                                                        },
                                                        isEdited: (val) {
                                                          searchResults[index] =
                                                              val;
                                                        },
                                                      ))),
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
                                                onPressed: () => Navigator.of(
                                                        context)
                                                    .push(MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            NotesOpenPage(
                                                              searchResults[
                                                                  index],
                                                              withEditing: true,
                                                              fromSearch: true,
                                                              isDeleted: (val) {
                                                                if (val) {
                                                                  searchResults
                                                                      .removeAt(
                                                                          index);
                                                                }
                                                              },
                                                              isEdited: (val) {
                                                                searchResults[
                                                                        index] =
                                                                    val;
                                                              },
                                                            )))),
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
                                                  shareNote(
                                                      '${searchResults[index].title}\n${searchResults[index].content}');
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
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                            title:
                                                                kDeleteConfirmationText,
                                                            onTapNegetive: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            onTapPositive: () {
                                                              Provider.of<NotesModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deleteNote(
                                                                      searchResults[
                                                                              index]
                                                                          .id);
                                                              searchResults
                                                                  .removeAt(
                                                                      index);

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
                                            color: kBackgroungColor
                                                .withOpacity(0.8),
                                          ),
                                          menuItemExtent: 50.toHeight,
                                          duration: Duration(milliseconds: 400),
                                          menuOffset: 10.toHeight,
                                          animateMenuItems: false,
                                          menuWidth:
                                              SizeConfig().screenWidth / 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10.toWidth,
                                                right: 10.toWidth,
                                                top: 12.toHeight),
                                            decoration: BoxDecoration(
                                                color: getColor(index),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child:
                                                      DynamicTextHighlighting(
                                                    text: searchResults[index]
                                                        .title
                                                        .toString(),
                                                    highlights: [
                                                      _searchController.text
                                                    ],
                                                    caseSensitive: false,
                                                    style: kNotesDefaultTextStyle
                                                        .copyWith(
                                                            color:
                                                                kBackgroungColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 0.2,
                                                            height: 1.2,
                                                            fontSize: index %
                                                                        7 ==
                                                                    2
                                                                ? 25.toFont
                                                                : (index % 7 ==
                                                                            3 ||
                                                                        index % 7 ==
                                                                            5)
                                                                    ? 23.toFont
                                                                    : 20.5
                                                                        .toFont),
                                                    maxLines: (index % 7 == 3 ||
                                                            index % 7 == 5)
                                                        ? 6
                                                        : index % 7 == 2
                                                            ? 3
                                                            : 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(height: 8.toHeight),
                                                Container(
                                                  child: Expanded(
                                                      child: ShaderMask(
                                                    blendMode: BlendMode.dstIn,
                                                    shaderCallback: (rect) {
                                                      return LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        stops: [0.4, 1.0],
                                                        colors: [
                                                          Colors.black,
                                                          Colors.transparent,
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
                                                        searchResults[index]
                                                            .content,
                                                        style: kNotesDefaultTextStyle
                                                            .copyWith(
                                                                color:
                                                                    kBackgroungColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                letterSpacing:
                                                                    0.2,
                                                                fontSize:
                                                                    18.toFont)),
                                                  )),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 12.toHeight),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                          DateFormat(
                                                                  'MMMM d, y')
                                                              .format(DateTime.tryParse(
                                                                  searchResults[
                                                                          index]
                                                                      .updatedAt)),
                                                          style: kNotesDefaultTextStyle
                                                              .copyWith(
                                                                  color: kButtonColor
                                                                      .withOpacity(
                                                                          0.6)))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
