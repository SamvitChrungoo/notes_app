import 'package:flutter/material.dart';
import 'package:notes_app/utils/size_config.dart';

class GradientList extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  const GradientList({@required this.backgroundColor, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
            top: 0,
            child: IgnorePointer(
              child: Container(
                height: 100.toHeight,
                width: SizeConfig().screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      backgroundColor.withOpacity(1.0),
                      backgroundColor.withOpacity(0.5),
                      backgroundColor.withOpacity(0.0),
                      Colors.transparent,
                    ],
                    stops: [0, 0.1, 0.2, 0.3],
                  ),
                ),
              ),
            )),
        Positioned(
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: 100.toHeight,
                width: SizeConfig().screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      backgroundColor.withOpacity(1.0),
                      backgroundColor.withOpacity(0.5),
                      backgroundColor.withOpacity(0.0),
                      Colors.transparent,
                    ],
                    stops: [0, 0.1, 0.2, 1],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
