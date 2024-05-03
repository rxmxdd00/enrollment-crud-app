import 'package:crud_app/components/reusable_textform_field.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:crud_app/utils/app_form_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../utils/constants.dart';

class EditCourseScreen extends StatefulWidget {
  final dynamic courseToEdit;
  const EditCourseScreen({super.key, required this.courseToEdit});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  String? name;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  var selectedVal;
  var courseId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.courseToEdit['courseName'].toString();
    selectedVal = widget.courseToEdit['departmentId'].toString();
    courseId = widget.courseToEdit['id'].toString();
  }

  @override
  Widget build(BuildContext context) {
    final departments = Provider.of<AppServices>(context);

    return FutureBuilder<List<dynamic>>(
      future: departments.getDepartmentsData(), // Await the Future
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error fetching department data');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No departments found');
        } else {
          final departmentItems = snapshot.data!.map<DropdownMenuItem<String>>(
            (item) {
              return DropdownMenuItem<String>(
                value: item['id'].toString(),
                child: Text(item['departmentName']),
              );
            },
          ).toList();

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
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            hint: const Text('Select Department'),
                            value: selectedVal,
                            items: departmentItems,
                            onChanged: (val) {
                              setState(() {
                                selectedVal = val;
                              });
                            },
                            validator: (val) =>
                                AppValidators.validateDepartmentName(
                                    context, val!),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ReusableTextField(
                        isObscure: false,
                        titleController: titleController,
                        valueChanged: (val) {
                          name = val;
                        },
                        hintText: 'Enter course name',
                        validators: (val) =>
                            AppValidators.validateCourse(context, val),
                      ),
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
                        'departmentId': selectedVal
                      };
                      Provider.of<AppServices>(context, listen: false)
                          .updateCourseData(dataTopass, courseId);
                      Navigator.pop(context);
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(kDefColor),
                  ),
                  child: Text(
                    'Update',
                    style: kCustomTitle.copyWith(
                        fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
