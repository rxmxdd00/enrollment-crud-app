import 'package:crud_app/models/navigation_model.dart';
import 'package:crud_app/screens/authentication_screen/login_screen.dart';
import 'package:crud_app/screens/course_screen/course_screen.dart';
import 'package:crud_app/screens/department_screen/department_screen.dart';
import 'package:crud_app/screens/enrollment_screen/enrollment_screen.dart';
import 'package:crud_app/screens/student_screen/student_screen.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import 'authentication_screen/register_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<BottomNavigationBarItem> item = [];
  int _currentIndex = 0;
  String? assignedRole;
  String? userName;
  List<NavigationModel> item = [
    NavigationModel(label: 'Enrollment', icon: Icons.topic_rounded),
    NavigationModel(label: 'Student', icon: Icons.person),
    NavigationModel(label: 'Course', icon: Icons.library_books),
    NavigationModel(label: 'Department', icon: Icons.supervisor_account),
  ];
  final List<Widget> _screens = [
    const Placeholder(
      child: EnrollmentScreen(),
    ),
    const Placeholder(
      child: StudentScreen(),
    ),
    const Placeholder(
      child: CourseScreen(),
    ),
    const Placeholder(
      child: DepartmentScreen(),
    ),
  ];
  void _performLogout() {
    // Navigate back to the login page
    Provider.of<AppServices>(context, listen: false).logout();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginScreen()),
    // );

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
    // Navigator.pop(context);
  }

  void getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');
    final String? firstName = prefs.getString('firstName');
    setState(() {
      assignedRole = role;
      userName = firstName;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hi, ${userName ?? ''}',
              style: const TextStyle(
                color: kDefColor,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Confirm Logout"),
                          content:
                              const Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                _performLogout(); // Call the logout function
                              },
                              child: Text("Logout"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    size: 40.0,
                    color: kDefColor,
                  ),
                ),
                if (assignedRole == 'admin')
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 40.0,
                      color: kDefColor,
                    ),
                  )
              ],
            )
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Color(0xffffffff), boxShadow: kElevationToShadow[2]),
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(color: kDefColor, fontSize: 14.0),
          unselectedLabelStyle:
              const TextStyle(color: kDefColor, fontSize: 12.0),
          type: BottomNavigationBarType.fixed,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          elevation: 2,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update the selected index
            });
          },
          items: item
              .map(
                (e) => _navigationBarItem(context, e.label!, e.icon!),
              )
              .toList(),
        ),
      ),
    );
  }
}

BottomNavigationBarItem _navigationBarItem(
    BuildContext context, String label, IconData icons) {
  return BottomNavigationBarItem(
    icon: Icon(
      icons,
      color: kDefColor,
    ),
    label: label,
    activeIcon: CircleAvatar(
      backgroundColor: Colors.grey.shade400,
      child: Icon(
        icons,
        color: kDefColor,
      ),
    ),
  );
}
