import 'package:chattie/pages/auth/login_page.dart';
import 'package:chattie/pages/auth/sign_up_page.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _isLoginPage = true;
  void _changeAuthPage() {
    setState(() {
      _isLoginPage = !_isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoginPage
        ? LoginPage(
            goToSignUpPage: _changeAuthPage,
          )
        : SignUpPage(
            goToLoginPage: _changeAuthPage,
          );
  }
}
