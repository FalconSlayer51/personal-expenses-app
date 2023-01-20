import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:personalexpenseapp/auth/auth_methods.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 50),
          margin: const EdgeInsets.only(bottom: 70),
          child: const Text(
            'PersonalExpenses',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 35,
              color: Colors.blue,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text(
            'Hey There ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 90,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              Container(
                padding:const EdgeInsets.only(left: 50),
                margin:const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Sign up now',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 60),
                child: GoogleAuthButton(
                  onPressed: () async {
                    bool res = await _authMethods.signInWithGoogle(context);
                    if (res == true) {
                      Navigator.pushReplacementNamed(context, '/homepage');
                    }
                  },
                  style: const AuthButtonStyle(
                    borderRadius: 30,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    buttonColor: Colors.blue,
                    iconType: AuthIconType.secondary,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
