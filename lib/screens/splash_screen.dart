import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/screens/notes_home_page.dart';
import 'package:notes_app/utils/hive_db.dart';
import 'package:notes_app/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  List<dynamic> data;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => NotesHomePage()),
        );
      }
    });
    getNotes();
    super.initState();
  }

  void getNotes() async {
    data = await HiveDataProvider.instance.readData('mynotes');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgroungColor,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/notes_animation.json',
          height: 300.toHeight,
          controller: _controller,
          onLoaded: (composition) async {
            _controller
              ..duration = composition.duration
              ..forward();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
