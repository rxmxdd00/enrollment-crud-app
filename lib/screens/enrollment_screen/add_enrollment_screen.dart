import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../utils/app_form_validators.dart';

class AddEnrollmentScreen extends StatefulWidget {
  final dynamic addEnrollmentCallback;
  final dynamic enrollmentList;
  const AddEnrollmentScreen(
      {super.key,
      required this.addEnrollmentCallback,
      required this.enrollmentList});

  @override
  State<AddEnrollmentScreen> createState() => _AddEnrollmentScreenState();
}

class _AddEnrollmentScreenState extends State<AddEnrollmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? studentId;
  String? courseId;
  TextEditingController _dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final enrollmentProvider = Provider.of<AppServices>(context);
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Text(
            textAlign: TextAlign.center,
            'Add Enrollments',
            style: kCustomTitle.copyWith(fontSize: 32.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<List<dynamic>>(
                  future: enrollmentProvider.getStudentsData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error loading data: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data available.');
                    } else {
                      final departments = snapshot.data!;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            hint: Text('Select Students'),
                            value: studentId,
                            items: departments.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'].toString(),
                                child: Text(
                                    '${item['firstName'] + ' ' + item['lastName']}'),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                studentId = newValue;
                              });
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please select a student.';
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FutureBuilder<List<dynamic>>(
                  future: enrollmentProvider.getCourseData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error loading data: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data available.');
                    } else {
                      final courses = snapshot.data!;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            hint: Text('Select Course'),
                            value: courseId,
                            items: courses.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'].toString(),
                                child: Text(item['courseName']),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                courseId = newValue;
                              });
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please select a course.';
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                        // icon: Icon(Icons.calendar_today),
                        suffixIcon: Icon(Icons.calendar_today),
                        labelText: 'Select Enrollment date'),
                    readOnly: true,
                    validator: (val) =>
                        AppValidators.validateEnrollmentDate(context, val!),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        initialDate: DateTime.now(),
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2050),
                      );

                      if (pickedDate != null) {
                        var formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          _dateController.text = formattedDate.toString();
                        });
                      } else {
                        print('please select a date first.');
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var dataTopass = {
                  'studentId': studentId,
                  'courseId': courseId,
                  'enrollment_date': _dateController.text
                };
                List<dynamic> enrollmentList = widget.enrollmentList;
                var isStudentExist = enrollmentList.where((items) {
                  final sId = items['studentId'].toString();
                  final cId = items['courseId'].toString();
                  return sId.contains(studentId.toString()) &&
                      cId.contains(courseId.toString());
                }).toList();

                if (isStudentExist.length > 0) {
                  print('This student has already enrolled to this course');
                  return;
                }

                setState(() {
                  Provider.of<AppServices>(context, listen: false)
                      .addEnrollmentData(dataTopass);
                });
                Navigator.pop(context);
              }
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(kDefColor),
            ),
            child: Text(
              'Add',
              style: kCustomTitle.copyWith(fontSize: 18.0, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 60.0,
          ),
        ],
      ),
    );
  }
}
