import 'package:crud_app/components/reusable_search_textfield.dart';
import 'package:crud_app/screens/department_screen/add_department_screen.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/reusable_modal_button.dart';
import '../../components/reusable_sort_dropdown.dart';
import '../../utils/constants.dart';
import '../../components/reusable_list.dart';

class DepartmentScreen extends StatefulWidget {
  static const String id = 'department_screen';
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  TextEditingController searchData = TextEditingController();
  List<dynamic> department = [];
  List<dynamic>? filteredData;
  String? search;

  bool isButtonDisabled = false;
  String? filterWith;
  List<Map<String, String>> filterOptions = [
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
        department.sort((a, b) {
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
        filteredData = department.where((item) {
          final departmentName = item['departmentName'];
          return departmentName.contains(val);
        }).toList();
      }
      isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final departmentProvider = Provider.of<AppServices>(context);
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
                    'Departments',
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
                      department = [];
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
                  addDialogScreen:
                      AddDepartmentScreen(addDepartmentCallback: () {
                    Navigator.pop(context);
                  }),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                FutureBuilder<List<dynamic>>(
                  future: departmentProvider.getDepartmentsData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading data: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data available.');
                    } else {
                      if (filteredData == null && department.isEmpty) {
                        department = snapshot.data!;
                      } else {
                        department = snapshot.data!;

                        if (filteredData != null) {
                          filteredData = department.where((item) {
                            final departmentName = item['departmentName'];
                            return departmentName.contains(search);
                          }).toList();

                          if (filterWith != null) {
                            filteredData!.sort((a, b) {
                              return a[filterWith].compareTo(b[filterWith]);
                            });
                          }
                        } else {
                          if (filterWith != null) {
                            department.sort((a, b) {
                              return a[filterWith].compareTo(b[filterWith]);
                            });
                          }
                        }
                      }

                      var data = {
                        'title': 'departmentName',
                        'sub_title': '',
                        'actionFrom': 'Department'
                      };
                      isButtonDisabled = false;
                      return SingleChildScrollView(
                        child: ReusableList(
                          list_data: filteredData ?? department,
                          tileData: data,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
