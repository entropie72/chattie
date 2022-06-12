import 'package:chattie/functions/validator.dart';
import 'package:chattie/models/user_model.dart';
import 'package:chattie/providers/providers.dart';
import 'package:chattie/utils/constants.dart';
import 'package:chattie/widgets/ui/base_button.dart';
import 'package:chattie/widgets/ui/base_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.goToLoginPage}) : super(key: key);
  final VoidCallback goToLoginPage;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _errorMessage = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isSomeFieldsNotValid() {
      if (_emailController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmationPasswordController.text.isEmpty) {
        setState(() {
          _errorMessage = 'All fiels must be filled!';
        });
        return true;
      }

      if (Validator.isPasswordNotLongEnough(_passwordController.text)) {
        setState(() {
          _errorMessage = 'Password should be at least 6 characters.';
        });
        return true;
      }

      if (Validator.isConfirmationPasswordNotMatch(
          _passwordController.text, _confirmationPasswordController.text)) {
        setState(() {
          _errorMessage =
              'The password and confirmation password do not match.';
        });
        return true;
      }

      return false;
    }

    void handleSignUp(WidgetRef ref) async {
      if (isSomeFieldsNotValid()) return;

      final FirebaseFirestore db = FirebaseFirestore.instance;

      final QuerySnapshot<Map> snapshot = await db
          .collection('users')
          .where('username', isEqualTo: _usernameController.text)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _errorMessage = 'This username is already in use by another account.';
        });
        return;
      }

      try {
        final snapshot =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        ref.refresh(currentUserUidProvider);
        final userId = snapshot.user!.uid;

        final UserModel user = UserModel(
          uid: userId,
          username: _usernameController.text,
        );

        await db.collection('users').doc(userId).set(user.userInfo());

        await db.collection('contacts').doc(userId).set({
          'contacts': [],
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message!;
        });
      }
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
                    labelText: 'Username',
                    controller: _usernameController,
                  ),
                  const SizedBox(
                    height: 12,
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
                  const SizedBox(
                    height: 12,
                  ),
                  BaseInput(
                    onTap: handleHideErrorMessage,
                    labelText: 'Confirm password',
                    controller: _confirmationPasswordController,
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
                    height: 24,
                  ),
                  Consumer(
                    builder: (context, ref, _) => BaseButton(
                      onTap: () => handleSignUp(ref),
                      child: const Text(
                        'Sign up',
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
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: subHeaderTextSize,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.goToLoginPage,
                        child: const Text(
                          'Log in.',
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
