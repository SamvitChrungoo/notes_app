import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/utils/size_config.dart';

class NotesButton extends StatelessWidget {
  @required
  final Function onTap;
  @required
  final Icon icon;
  final double height;
  final double width;
  final double borderRadius;

  NotesButton({
    this.onTap,
    this.icon,
    this.borderRadius = 10.0,
    this.height = 42.0,
    this.width = 42.0,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
          padding: EdgeInsets.only(bottom: 2.toHeight),
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kButtonColor,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
          child: icon),
    );
  }
}
