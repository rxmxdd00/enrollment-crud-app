import 'package:crud_app/components/reusable_textform_field.dart';
import 'package:crud_app/utils/app_form_validators.dart';
import 'package:crud_app/utils/constants.dart';
import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDepartmentScreen extends StatelessWidget {
  final Function addDepartmentCallback;
  const AddDepartmentScreen({super.key, required this.addDepartmentCallback});
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    String? name;
    final _formKey = GlobalKey<FormState>();
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            textAlign: TextAlign.center,
            'Add Department',
            style: kCustomTitle.copyWith(fontSize: 32.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Form(
            key: _formKey,
            child: ReusableTextField(
              isObscure: false,
              titleController: titleController,
              valueChanged: (val) {
                name = val;
              },
              hintText: 'Please enter department name',
              validators: (val) {
                if (val.isEmpty || val.trim().isEmpty) {
                  return 'Please enter a valid department name';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<AppServices>(context, listen: false)
                    .addDepartmentData(name!);
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
