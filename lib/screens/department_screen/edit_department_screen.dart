import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/reusable_textform_field.dart';
import '../../utils/app_form_validators.dart';
import '../../utils/constants.dart';

class EditDepartmentScreen extends StatefulWidget {
  static const id = 'edit_department_screen';

  final dynamic selectedDepartment;
  const EditDepartmentScreen({super.key, required this.selectedDepartment});

  @override
  State<EditDepartmentScreen> createState() => _EditDepartmentScreenState();
}

class _EditDepartmentScreenState extends State<EditDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? depId;
  TextEditingController _controller = TextEditingController();
  String? name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = widget.selectedDepartment['departmentName'].toString();
    depId = widget.selectedDepartment['id'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              textAlign: TextAlign.center,
              'Edit Department',
              style: kCustomTitle.copyWith(fontSize: 32.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ReusableTextField(
                    isObscure: false,
                    titleController: _controller,
                    valueChanged: (val) {
                      name = val;
                    },
                    hintText: 'Enter department name',
                    validators: (val) {
                      if (val.isEmpty || val.trim().isEmpty) {
                        return 'Please enter a valid department name';
                      }
                      return null;
                    },
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
                  Provider.of<AppServices>(context, listen: false)
                      .updateDepartmentData(name, depId);
                  Navigator.pop(context);
                }
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(kDefColor),
              ),
              child: Text(
                'Update',
                style:
                    kCustomTitle.copyWith(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
