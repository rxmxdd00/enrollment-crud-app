import 'package:crud_app/components/reusable_textform_field.dart';
import 'package:crud_app/screens/authentication_screen/register_screen.dart';
import 'package:crud_app/screens/home_screen.dart';
import 'package:crud_app/utils/app_form_validators.dart';
import 'package:crud_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/app_services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;

  void _handleRemeberme(value) {
    if (_emailController.text != '' || _passwordController.text != '') {
      _isChecked = value;
      SharedPreferences.getInstance().then(
        (prefs) {
          prefs.setBool("remember_me", value);
          prefs.setString('email', _emailController.text);
          prefs.setString('password', _passwordController.text);
        },
      );
    }
    setState(() {
      _isChecked = value;
    });
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        _emailController.text = _email ?? "";
        _passwordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserEmailPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ProgressHUD(
          child: Builder(builder: (context) {
            return Padding(
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
                          titleController: _emailController,
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
                          titleController: _passwordController,
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
                        final progress = ProgressHUD.of(context);
                        progress?.showWithText('Loading...');
                        var data = {
                          'email': _emailController.text,
                          'password': _passwordController.text,
                        };
                        var loginData = await Provider.of<AppServices>(context,
                                listen: false)
                            .loginAccount(data);
                        if (loginData != null) {
                          await prefs.setString(
                              'token', loginData['data']['token']);
                          await prefs.setString(
                              'email', loginData['data']['email']);
                          await prefs.setString(
                              'firstName', loginData['data']['firstName']);
                          await prefs.setString(
                              'lastName', loginData['data']['lastName']);
                          await prefs.setString(
                              'role', loginData['data']['role']);
                          Future.delayed(Duration(seconds: 1), () {
                            progress!.dismiss();
                          });
                          Navigator.pushNamed(context, HomeScreen.id);
                        }
                      }
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(kDefColor),
                    ),
                    child: Text(
                      'Login',
                      style: kCustomTitle.copyWith(
                          fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Color(0xff00C8E8) // Your color
                              ),
                          child: Checkbox(
                              activeColor: kDefColor,
                              value: _isChecked,
                              onChanged: _handleRemeberme),
                        )),
                    const SizedBox(width: 10.0),
                    const Text(
                      "Remember Me",
                      style: TextStyle(
                          color: Color(0xff646464),
                          fontSize: 18.0,
                          fontFamily: 'Rubic'),
                    ),
                  ]),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text(
                  //       'Do you have an account?',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 5.0,
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.pushNamed(context, RegisterScreen.id);
                  //       },
                  //       child: const Text(
                  //         'Sign-up!',
                  //         style: TextStyle(
                  //             fontSize: 16.0,
                  //             fontWeight: FontWeight.w900,
                  //             color: kDefColor),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
