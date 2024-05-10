import 'package:crud_app/components/reusable_search_textfield.dart';
import 'package:crud_app/screens/course_screen/add_course_screen.dart';
import 'package:crud_app/screens/department_screen/department_screen.dart';
import 'package:crud_app/components/reusable_list.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/reusable_modal_button.dart';
import '../../components/reusable_sort_dropdown.dart';
import '../../utils/constants.dart';

class CourseScreen extends StatefulWidget {
  static const String id = 'course_screen';
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  TextEditingController searchData = TextEditingController();
  List<dynamic> course = [];
  List<dynamic>? filteredData;
  String? search;

  bool isButtonDisabled = false;
  String? filterWith;
  List<Map<String, String>> filterOptions = [
    {'value': 'courseName', 'viewValue': 'Course'},
    {'value': 'departmentName', 'viewValue': 'Department'},
    {'value': 'created_at', 'viewValue': 'Created At'}
  ];

  void _onFilteredText(String val) {
    setState(() {
      if (filteredData != null) {
        filterWith = val;
        filteredData!.sort((a, b) {
          return a[val].compareTo(b[val]);
        });
      } else {
        filterWith = val;
        course.sort((a, b) {
          return a[val].compareTo(b[val]);
        });
      }
    });
  }

  void _onSearchText(String val) {
    setState(() {
      if (val == '' || val == null) {
        filteredData = null;
      } else {
        search = val;
        filteredData = course.where((item) {
          final departmentName = item['departmentName'];
          final courseName = item['courseName'];
          return departmentName.contains(val) || courseName.contains(val);
        }).toList();
      }
      isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<AppServices>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kIntroHeadPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Course',
                    style: kCustomTitle.copyWith(fontSize: 32.0),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                ReusableSearchTextField(
                    searchController: searchData,
                    searchCallback: _onSearchText),
                const SizedBox(
                  height: 15.0,
                ),
                ReusableSortData(
                  onTap: () {
                    setState(() {
                      filteredData = null;
                      filterWith = null;
                      search = null;
                      searchData.text = '';
                      course = [];
                    });
                  },
                  onChanged: (val) => _onFilteredText(val),
                  filterWith: filterWith,
                  filterOptions: filterOptions,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                ReusableModalButton(
                  isDisabled: isButtonDisabled,
                  addDialogScreen: AddCourseScreen(
                    addCourseCallback: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                FutureBuilder<List<dynamic>>(
                  future: courseProvider.getCourseData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      isButtonDisabled = true;
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading data: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data available.');
                    } else {
                      var failData = snapshot.data![0];
                      if (failData['success'] == false) {
                        return Center(child: Text('${failData['message']}'));
                      }
                      if (filteredData == null && course.isEmpty) {
                        course = snapshot.data!;
                      } else {
                        course = snapshot.data!;

                        if (filteredData != null) {
                          filteredData = course.where((item) {
                            final departmentName = item['departmentName'];
                            final courseName = item['courseName'];
                            return departmentName.contains(search) ||
                                courseName.contains(search);
                          }).toList();

                          if (filterWith != null) {
                            filteredData!.sort((a, b) {
                              return a[filterWith].compareTo(b[filterWith]);
                            });
                          }
                        } else {
                          if (filterWith != null) {
                            course.sort((a, b) {
                              return a[filterWith].compareTo(b[filterWith]);
                            });
                          }
                        }
                      }
                      var data = {
                        'title': 'courseName',
                        'sub_title': 'departmentName',
                        'actionFrom': 'Course'
                      };
                      isButtonDisabled = false;
                      return course.length > 0
                          ? ReusableList(
                              list_data: filteredData ?? course, tileData: data)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_card,
                                  size: 100.0,
                                  color: Colors.grey.shade500,
                                ),
                                Text(
                                  'No data',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.grey.shade500),
                                )
                              ],
                            );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
