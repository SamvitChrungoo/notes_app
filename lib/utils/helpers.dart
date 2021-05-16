import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:share/share.dart';

const colorList = [
  kStickyNotesRed,
  kStickyNotesOrange,
  kStickyNotesLime,
  kStickyNotesBlue,
  kStickyNotesPurple,
  kStickyNotesPink,
  kStickyNotesTeal,
];

const tileList = [
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(4, 2),
  StaggeredTile.count(2, 3),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 3),
  StaggeredTile.count(2, 2),
];

Color getColor(int index) {
  if (index < 7)
    return colorList[index];
  else {
    var newIdex = index % 7;
    return colorList[newIdex];
  }
}

StaggeredTile getTileShape(int index) {
  if (index < 7)
    return tileList[index];
  else {
    var newIdex = index % 7;
    return tileList[newIdex];
  }
}

void shareNote(String text) {
  Share.share(text, subject: 'Sent from myMemo app');
}
