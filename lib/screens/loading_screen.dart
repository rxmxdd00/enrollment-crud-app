import 'package:crud_app/utils/constants.dart';
import 'package:crud_app/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LoadingScreen extends StatefulWidget {
  static const id = "loading_screen";
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final _timeDuration = 3000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: _timeDuration + 500), () {
      Navigator.pushReplacementNamed(context, OnBoardingScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val) => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("images/app-logo.png"),
          //     fit: BoxFit.cover,
          //     alignment: Alignment.topCenter,
          //   ),
          // ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 170, bottom: 50),
                  child: const Hero(
                      tag: 'appLogo',
                      child: Image(
                        image: AssetImage('images/app-logo.png'),
                      )),
                ),
                const Text(
                  'Loading the application',
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 2),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 100),
                  duration: Duration(milliseconds: _timeDuration),
                  builder: (BuildContext context, double val, Widget? child) {
                    return Column(
                      children: [
                        Text(
                          "${val.toInt()}%",
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              color: kDefColor,
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: 20.0,
                                percent: val / 100,
                                barRadius: const Radius.circular(10),
                                progressColor: kDefColor,
                                backgroundColor: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: const Icon(Icons.aspect_ratio),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
