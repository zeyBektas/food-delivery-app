import 'package:delivery_app/components/my_button.dart';
import 'package:delivery_app/components/my_textfield.dart';
import 'package:delivery_app/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register() async {
    final _authService = AuthService();

    if (passwordController.text == confirmPasswordController.text) {
      try {
        await _authService.signUpWithEmailPassword(emailController.text, passwordController.text);
      }
      catch(e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(e.toString()),
          )
        );
      }
    }
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text("Passwords don't match"),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_open_rounded,
                size: 72,
                color: Theme
                    .of(context)
                    .colorScheme
                    .inversePrimary,
              ),

              SizedBox(height: 25,),

              Text(
                "Let's create an account for you",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .inversePrimary,
                ),
              ),

              SizedBox(height: 25,),

              MyTextfield(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),

              SizedBox(height: 10,),

              MyTextfield(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),

              SizedBox(height: 10,),

              MyTextfield(
                controller: confirmPasswordController,
                hintText: "Confirm password",
                obscureText: true,
              ),

              SizedBox(height: 10,),

              MyButton(
                text: "Sign Up",
                onTap: register,
              ),

              SizedBox(height: 25,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .inversePrimary,
                    ),
                  ),
                  SizedBox(width: 4,),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}
