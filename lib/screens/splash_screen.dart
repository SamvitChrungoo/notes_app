import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/constants/constant_colors.dart';
import 'package:notes_app/provider/notes_model.dart';
import 'package:notes_app/screens/notes_home_page.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;

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
    Provider.of<NotesModel>(context, listen: false).getNotes();
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
