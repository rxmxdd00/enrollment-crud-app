import 'package:crud_app/screens/authentication_screen/login_screen.dart';
import 'package:crud_app/screens/home_screen.dart';
import 'package:crud_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  static const id = 'onboarding_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: "Welcome to Enrollment App",
                body:
                    "Discover seamless enrollment and manage data effortlessly with its intuitive features.",
                image: Image.asset("images/middle_school.png"),
              ),
              PageViewModel(
                title: "Applying CRUD Operations",
                body:
                    "Learn how to create, read, update, and delete records in just a few clicks!",
                footer: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(kDefColor),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                image: Image.asset("images/students_n_book.png"),
              ),
            ],
            showSkipButton: false,
            skip: const Text('Skip',
                style: TextStyle(fontWeight: FontWeight.w600)),
            next: const Icon(Icons.arrow_forward),
            showNextButton: false,
            done: const Text('Proceed',
                style: TextStyle(fontWeight: FontWeight.w600)),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            onDone: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            showDoneButton: false,
          ),
        ),
      ),
    );
  }
}
