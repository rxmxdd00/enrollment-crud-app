import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/reusable_textform_field.dart';
import '../../utils/constants.dart';
import '../../utils/app_form_validators.dart';

class EditStudentScreen extends StatefulWidget {
  const EditStudentScreen({super.key, required this.studentToEdit});

  final dynamic studentToEdit;
  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  String? fname;
  String? lname;
  String? address;
  String? studentId;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController.text = widget.studentToEdit['firstName'].toString();
    _lastNameController.text = widget.studentToEdit['lastName'].toString();
    _addressController.text = widget.studentToEdit['address'].toString();
    _dateController.text = widget.studentToEdit['DOB'];
    studentId = widget.studentToEdit['id'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            textAlign: TextAlign.center,
            'Edit Students',
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
                  titleController: _firstNameController,
                  valueChanged: (val) {
                    fname = val;
                  },
                  hintText: 'Enter your first name',
                  validators: (val) =>
                      AppValidators.validateFirstname(context, val),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ReusableTextField(
                  isObscure: false,
                  titleController: _lastNameController,
                  valueChanged: (val) {
                    lname = val;
                  },
                  hintText: 'Enter your last name',
                  validators: (val) =>
                      AppValidators.validateLastname(context, val),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ReusableTextField(
                  isObscure: false,
                  titleController: _addressController,
                  valueChanged: (val) {
                    address = val;
                  },
                  hintText: 'Enter your address',
                  validators: (val) =>
                      AppValidators.validateAddress(context, val),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: 'Enter birthdate'),
                    readOnly: true,
                    validator: (val) =>
                        AppValidators.validateBirthdate(context, val!),
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
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var dataToPass = {
                  'firstName': _firstNameController.text,
                  'lastName': _lastNameController.text,
                  'address': _addressController.text,
                  'DOB': _dateController.text,
                };
                Provider.of<AppServices>(context, listen: false)
                    .updateStudentData(dataToPass, studentId);
                Navigator.pop(context);
              }
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(kDefColor),
            ),
            child: Text(
              'Update',
              style: kCustomTitle.copyWith(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
