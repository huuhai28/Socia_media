// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatefulWidget {
  final bool showLoginPage;
  const AuthPage({
    Key? key,
    this.showLoginPage = true,
  }) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool showLoginPage = widget.showLoginPage;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginPage(
            toggleRegisterPage: togglePages,
          )
        : RegisterPage(
            toggleLoginPage: togglePages,
          );
  }
}
