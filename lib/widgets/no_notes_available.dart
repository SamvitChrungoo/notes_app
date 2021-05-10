import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/constants/constants.dart';
import 'package:notes_app/utils/size_config.dart';

class NoNotesAvailable extends StatefulWidget {
  @override
  _NoNotesAvailableState createState() => _NoNotesAvailableState();
}

class _NoNotesAvailableState extends State<NoNotesAvailable>
    with TickerProviderStateMixin {
  AnimationController _controller;
  int haha = 0;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        // SizedBox(height: 24.toHeight),
        Opacity(
          opacity: 0.6,
          child: Lottie.asset('assets/lottie/empty_notes.json',
              height: 250, width: 250),
        ),
        Text("Click the '+' icon to add a \nnew note !!",
            textAlign: TextAlign.center,
            style: kNotesDefaultHeadingStyle.copyWith(
                letterSpacing: 0.6,
                fontSize: 22,
                color: kTextColor.withOpacity(0.6))),
        SizedBox(height: 20.toHeight),
        Container(
          margin: EdgeInsets.only(left: 70.toWidth),
          child: Opacity(
            opacity: 0.5,
            child: Transform.rotate(
              angle: 3 * pi / 2,
              child: Lottie.asset(
                'assets/lottie/arrow_down.json',
                height: 150.toHeight,
                width: 150.toWidth,
                repeat: false,
                controller: _controller,
                onLoaded: (composition) async {
                  await Future.delayed(Duration(seconds: 1));
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
