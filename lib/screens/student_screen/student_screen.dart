import 'package:crud_app/components/reusable_search_textfield.dart';
import 'package:crud_app/screens/student_screen/add_student_screen.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/reusable_list.dart';
import '../../components/reusable_modal_button.dart';
import '../../components/reusable_sort_dropdown.dart';
import '../../utils/constants.dart';
import '../department_screen/department_screen.dart';

class StudentScreen extends StatefulWidget {
  static const String id = 'student_screen';
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  TextEditingController searchData = TextEditingController();
  List<dynamic> student = [];
  List<dynamic>? filteredData;
  String? search;

  bool isButtonDisabled = false;
  String? filterWith;
  List<Map<String, String>> filterOptions = [
    {'value': 'firstName', 'viewValue': 'First Name'},
    {'value': 'lastName', 'viewValue': 'Last Name'},
    {'value': 'address', 'viewValue': 'Address'}
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
        student.sort((a, b) {
          return a[val].compareTo(b[val]);
        });
      }
    });
  }

  void _onSearchText(String val) {
    if (val == '' || val == null) {
      filteredData = null;
    } else {
      setState(() {
        search = val;
        filteredData = student.where((item) {
          final firstName = item['firstName'];
          final lastName = item['lastName'];
          final address = item['address'];
          return firstName.contains(val) ||
              lastName.contains(val) ||
              address.contains(val);
        }).toList();
        isButtonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<AppServices>(context);
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
                    'Students',
                    style: kCustomTitle.copyWith(fontSize: 32.0),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
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
                      student = [];
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
                  addDialogScreen: AddStudentScreen(
                    addStudentCallBack: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                FutureBuilder<List<dynamic>>(
                  future: studentProvider.getStudentsData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      isButtonDisabled = true;
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading data: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data available.');
                    } else {
                      var dlength = snapshot.data!.length;

                      if (filteredData == null && student.isEmpty) {
                        student = snapshot.data!;
                      } else {
                        student = snapshot.data!;

                        if (filteredData != null) {
                          filteredData = student.where((item) {
                            final firstName = item['firstName'];
                            final lastName = item['lastName'];
                            final address = item['address'];
                            return firstName.contains(search) ||
                                lastName.contains(search) ||
                                address.contains(search);
                          }).toList();

                          if (filterWith != null) {
                            filteredData!.sort((a, b) {
                              return a[filterWith].compareTo(b[filterWith]);
                            });
                          }
                        } else {
                          if (filterWith != null) {
                            student.sort((a, b) {
                              return a[filterWith].compareTo(b[filterWith]);
                            });
                          }
                        }
                      }
                      var data = {
                        'title': 'name',
                        'sub_title': 'address',
                        'actionFrom': 'Student'
                      };
                      isButtonDisabled = false;
                      return ReusableList(
                          list_data: filteredData ?? student, tileData: data);
                    }
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
