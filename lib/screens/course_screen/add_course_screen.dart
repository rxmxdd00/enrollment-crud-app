import 'package:crud_app/components/reusable_textform_field.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:crud_app/utils/app_form_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../utils/constants.dart';

class AddCourseScreen extends StatefulWidget {
  final Function addCourseCallback;
  const AddCourseScreen({
    super.key,
    required this.addCourseCallback,
  });

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  String? selectedDepartmentId;
  String? name;

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<AppServices>(context);
    TextEditingController titleController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            textAlign: TextAlign.center,
            'Add Course',
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
                  future: courseProvider.getDepartmentsData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
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
                            hint: Text('Select Department'),
                            value: selectedDepartmentId,
                            items: departments.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'].toString(),
                                child: Text(item['departmentName']),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDepartmentId = newValue;
                              });
                            },
                            validator: (val) {
                              if (val == null) {
                                return 'Please select department';
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
                ReusableTextField(
                    isObscure: false,
                    titleController: titleController,
                    valueChanged: (val) {
                      name = val;
                      print(name);
                    },
                    hintText: 'Enter Course Name',
                    validators: (val) =>
                        AppValidators.validateCourseName(context, val)),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var dataTopass = {
                  'courseName': name,
                  'departmentId': selectedDepartmentId
                };
                setState(() {
                  Provider.of<AppServices>(context, listen: false)
                      .addCourseData(dataTopass);
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
        ],
      ),
    );
  }
}
