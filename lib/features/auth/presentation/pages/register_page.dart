// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../cubits/auth_cubits.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? toggleLoginPage;

  const RegisterPage({super.key, required this.toggleLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmPw = confirmPwController.text;

    final AuthCubit authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty &&
        name.isNotEmpty) {
      // ensure pw match
      if (confirmPw == pw) {
        authCubit.register(name, email, pw);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Confirm Password doesn't match")));
      }
    }
    // fields are empty -> display error
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete all fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Icon(
                    Icons.lock_open_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 80,
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // welcome back msg
                  Text(
                    "Let create an account for you",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // name textfield
                  MyTextfield(
                    hintText: "Name",
                    obscureText: false,
                    controller: nameController,
                  ),

                  const SizedBox(height: 10),

                  // email textfield
                  MyTextfield(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextfield(
                    hintText: "Password",
                    obscureText: true,
                    controller: pwController,
                  ),
                  const SizedBox(height: 10),

                  // password textfield
                  MyTextfield(
                    hintText: "Confirm password",
                    obscureText: true,
                    controller: confirmPwController,
                  ),
                  const SizedBox(height: 40),

                  MyButton(
                    text: "Register",
                    ontap: register,
                  ),

                  const SizedBox(height: 25),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.toggleLoginPage,
                        child: Text(
                          "Login now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
