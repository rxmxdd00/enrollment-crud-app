import 'package:crud_app/components/reusable_search_textfield.dart';
import 'package:crud_app/screens/enrollment_screen/add_enrollment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/reusable_list.dart';
import '../../components/reusable_modal_button.dart';
import '../../components/reusable_sort_dropdown.dart';
import '../../utils/constants.dart';
import '../../services/app_services.dart';
import '../department_screen/department_screen.dart';

class EnrollmentScreen extends StatefulWidget {
  static const String id = 'enrollment_screen';
  const EnrollmentScreen({super.key});

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  TextEditingController searchData = TextEditingController();
  List<dynamic> enrollment = [];
  List<dynamic>? filteredData;
  String? search;
  bool isButtonDisabled = false;
  String? filterWith;
  List<Map<String, String>> filterOptions = [
    {'value': 'lastName', 'viewValue': 'Students'},
    {'value': 'courseName', 'viewValue': 'Course'},
    {'value': 'created_at', 'viewValue': 'Created At'}
  ];

  void _onSearchText(String val) {
    if (val == '' || val == null) {
      filteredData = null;
    } else {
      setState(() {
        search = val;
        filteredData = enrollment.where((item) {
          final firstName = item['firstName'];
          final lastName = item['lastName'];
          final courseName = item['courseName'];
          return firstName.contains(val) ||
              lastName.contains(val) ||
              courseName.contains(val);
        }).toList();
        isButtonDisabled = false;
      });
    }
  }

  void _onFilteredText(String val) {
    setState(() {
      filterWith = val;
      if (filteredData != null) {
        filteredData!.sort((a, b) {
          return a[val].compareTo(b[val]);
        });
      } else {
        enrollment.sort((a, b) {
          return a[val].compareTo(b[val]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final enrollmentProvider = Provider.of<AppServices>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Enrollments',
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
                      enrollment = [];
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
                  addDialogScreen: AddEnrollmentScreen(
                    enrollmentList: enrollment,
                    addEnrollmentCallback: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                FutureBuilder<List<dynamic>>(
                  future: enrollmentProvider.getEnrollmentData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      isButtonDisabled = true;
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print(snapshot);
                      return Text('Error loading data: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('No data available.');
                    } else {
                      var failData = snapshot.data![0];
                      if (failData['success'] == false) {
                        return Center(child: Text('${failData['message']}'));
                      }
                      if (filteredData == null && enrollment.isEmpty) {
                        enrollment = snapshot.data!;
                      } else {
                        enrollment = snapshot.data!;

                        if (filteredData != null) {
                          filteredData = enrollment.where((item) {
                            final firstName = item['firstName'];
                            final lastName = item['lastName'];
                            final courseName = item['courseName'];
                            return firstName.contains(search) ||
                                lastName.contains(search) ||
                                courseName.contains(search);
                          }).toList();

                          if (filterWith != null) {
                            filteredData!.sort((a, b) {
                              return a[filterWith].compareTo(b[filterWith]);
                            });
                          }
                        } else {
                          if (filterWith != null) {
                            enrollment.sort((a, b) {
                              return a[filterWith].compareTo(b[filterWith]);
                            });
                          }
                        }
                      }
                      isButtonDisabled = false;
                      var data = {
                        'title': 'name',
                        'sub_title': 'courseName',
                        'actionFrom': 'Enrollment'
                      };
                      return enrollment.length > 0
                          ? ReusableList(
                              list_data: filteredData ?? enrollment,
                              tileData: data)
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
