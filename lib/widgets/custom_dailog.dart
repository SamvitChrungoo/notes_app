import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/constants/constants.dart';
import 'package:notes_app/utils/size_config.dart';

class CustomDialogBox extends StatefulWidget {
  final String title;
  final Function onTapPositive, onTapNegetive;

  const CustomDialogBox(
      {Key key, this.title, this.onTapPositive, this.onTapNegetive});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.toWidth),
          padding: EdgeInsets.only(top: 20.toHeight),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: kBackgroungColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 5), blurRadius: 5)
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.toWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.title,
                  style: kNotesDefaultHeadingStyle.copyWith(
                      letterSpacing: 0.5, fontSize: 20.toFont),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40.toHeight,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 45.toHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                widget.onTapNegetive();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: kButtonColor),
                                      right: BorderSide(color: kButtonColor),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('No',
                                      style: kNotesDefaultTextStyle.copyWith(
                                          fontSize: 18.toFont))),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                widget.onTapPositive();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: kButtonColor),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Yes',
                                      style: kNotesDefaultTextStyle.copyWith(
                                          color: Colors.redAccent,
                                          fontSize: 18.toFont))),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
