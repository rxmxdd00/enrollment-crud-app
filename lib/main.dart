import 'package:crud_app/screens/authentication_screen/login_screen.dart';
import 'package:crud_app/screens/authentication_screen/register_screen.dart';
import 'package:crud_app/screens/course_screen/course_screen.dart';
import 'package:crud_app/screens/department_screen/department_screen.dart';
import 'package:crud_app/screens/enrollment_screen/enrollment_screen.dart';
import 'package:crud_app/screens/home_screen.dart';
import 'package:crud_app/screens/student_screen/student_screen.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:crud_app/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppServices(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: OnBoardingScreen.id,
        routes: {
          OnBoardingScreen.id: (context) => OnBoardingScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          DepartmentScreen.id: (context) => const DepartmentScreen(),
          CourseScreen.id: (context) => const CourseScreen(),
          StudentScreen.id: (context) => const StudentScreen(),
          EnrollmentScreen.id: (context) => const EnrollmentScreen(),
        },
      ),
    );
  }
}
