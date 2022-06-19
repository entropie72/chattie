import 'package:chattie/functions/validator.dart';
import 'package:chattie/providers/providers.dart';
import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/ui/base_button.dart';
import 'package:chattie/widgets/ui/base_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.goToSignUpPage}) : super(key: key);
  final VoidCallback goToSignUpPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _errorMessage = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isSomeFieldsNotValid() {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        setState(() {
          _errorMessage = 'All fields must be filled!';
        });
        return true;
      }
      if (Validator.isPasswordNotLongEnough(_passwordController.text)) {
        setState(() {
          _errorMessage = 'Password should be at least 6 characters.';
        });
        return true;
      }

      return false;
    }

    void handleLogin(WidgetRef ref) async {
      if (isSomeFieldsNotValid()) return;

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message!;
        });
      }
      ref.refresh(currentUserUidProvider);
    }

    void handleHideErrorMessage() {
      setState(() {
        _errorMessage = '';
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: 60,
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  BaseInput(
                    onTap: handleHideErrorMessage,
                    labelText: 'Email address',
                    controller: _emailController,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  BaseInput(
                    onTap: handleHideErrorMessage,
                    labelText: 'Password',
                    controller: _passwordController,
                    isObscureText: true,
                  ),
                  if (_errorMessage.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                                fontSize: footNoteTextSize,
                                color: Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: primaryColor, fontSize: subHeaderTextSize),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Consumer(
                    builder: (context, ref, child) => BaseButton(
                      onTap: () => handleLogin(ref),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: calloutTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          fontSize: subHeaderTextSize,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.goToSignUpPage,
                        child: const Text(
                          'Sign Up.',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: subHeaderTextSize,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
