import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/constants/constants.dart';
import 'package:notes_app/utils/size_config.dart';

class NoNotesAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60.toHeight),
        Text("You don't have any saved notes yet !",
            textAlign: TextAlign.center,
            style: kNotesDefaultHeadingStyle.copyWith(
                letterSpacing: 0.6,
                fontSize: 22,
                color: kTextColor.withOpacity(0.6))),
        SizedBox(height: 24.toHeight),
        Container(
            height: 120.toHeight,
            child: Image.asset(
              kNotesNotFoundIcon,
              color: kTextColor.withOpacity(0.4),
            )),
        SizedBox(height: 24.toHeight),
        Text("Click the '+' icon to add a \nnew note !!",
            textAlign: TextAlign.center,
            style: kNotesDefaultHeadingStyle.copyWith(
                letterSpacing: 0.6,
                fontSize: 22,
                color: kTextColor.withOpacity(0.6))),
        SizedBox(height: 60.toHeight),
        Container(
          // color: Colors.green,
          width: 200.toWidth,
          child: Image.asset(
            kCurveArrowIcon,
            color: kTextColor.withOpacity(0.4),
            fit: BoxFit.fitWidth,
          ),
        )
      ],
    );
  }
}
