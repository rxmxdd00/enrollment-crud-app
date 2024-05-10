import 'package:crud_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../components/reusable_textform_field.dart';
import '../../utils/app_form_validators.dart';
import '../../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController c_password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    c_password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<AppServices>(context);
    return Scaffold(
      body: SafeArea(
        child: ProgressHUD(
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: kIntroHeadPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      'Register Account',
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
                            hintText: 'Enter first name',
                            valueChanged: (val) {},
                            titleController: firstName,
                            validators: (val) =>
                                AppValidators.validateFirstname(context, val),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ReusableTextField(
                            isObscure: false,
                            hintText: 'Enter last name',
                            valueChanged: (val) {},
                            titleController: lastName,
                            validators: (val) =>
                                AppValidators.validateLastname(context, val),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ReusableTextField(
                            isObscure: false,
                            hintText: 'Enter your email',
                            valueChanged: (val) {},
                            titleController: email,
                            validators: (val) =>
                                AppValidators.validateEmail(context, val),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ReusableTextField(
                            hintText: 'Enter your password',
                            isObscure: true,
                            valueChanged: (val) {},
                            titleController: password,
                            validators: (val) =>
                                AppValidators.validatePassword(context, val),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ReusableTextField(
                              hintText: 'Confirm your password',
                              isObscure: true,
                              valueChanged: (val) {},
                              titleController: c_password,
                              validators: (val) {
                                if (val.isEmpty || val.trim().isEmpty) {
                                  return 'Please select a students';
                                }
                                if (c_password.text != password.text) {
                                  return 'Password not match';
                                }
                                return null;
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextButton(
                      onPressed: () async {
                        final progress = ProgressHUD.of(context);

                        if (_formKey.currentState!.validate()) {
                          var data = {
                            'firstName': firstName.text,
                            'lastName': lastName.text,
                            'email': email.text,
                            'password': password.text,
                            'c_password': c_password.text,
                            'role': 'user'
                          };
                          progress?.showWithText('Loading...');
                          var regData = await Provider.of<AppServices>(context,
                                  listen: false)
                              .registerAccount(data);

                          if (regData != null) {
                            Future.delayed(Duration(seconds: 1), () {
                              progress!.dismiss();
                            });
                          }
                          // setState(() {
                          //
                          //  Provider.of<AppServices>(context, listen: false).registerAccount(data);
                          // });
                          Navigator.pop(context);
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(kDefColor),
                      ),
                      child: Text(
                        'Register',
                        style: kCustomTitle.copyWith(
                            fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        const SizedBox(
                          width: 10.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign-In!',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                color: kDefColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
