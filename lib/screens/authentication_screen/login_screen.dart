import 'package:crud_app/components/reusable_textform_field.dart';
import 'package:crud_app/screens/authentication_screen/register_screen.dart';
import 'package:crud_app/screens/home_screen.dart';
import 'package:crud_app/utils/app_form_validators.dart';
import 'package:crud_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/app_services.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kIntroHeadPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150.0,
                    child: Image.asset('images/app-logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                textAlign: TextAlign.center,
                'Login Account',
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
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (_formKey.currentState!.validate()) {
                    var data = {
                      'email': email.text,
                      'password': password.text,
                    };
                    var loginData =
                        await Provider.of<AppServices>(context, listen: false)
                            .loginAccount(data);

                    if (loginData != null) {
                      await prefs.setString(
                          'token', loginData['data']['token']);
                      await prefs.setString('name', loginData['data']['name']);
                      Navigator.pushNamed(context, HomeScreen.id);
                    }
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(kDefColor),
                ),
                child: Text(
                  'Login',
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
                  const Text('Do you have an account?'),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                    child: const Text(
                      'Sign-up!',
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
      ),
    );
  }
}
