import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_network_test/screens/auth_module/Register/register_screen.dart';
import 'package:social_network_test/screens/auth_module/login/local_widgets/social_icon.dart';
import 'package:social_network_test/screens/auth_module/login/login_viewmodel.dart';
import 'package:social_network_test/widgets/background.dart';
import 'package:social_network_test/widgets/do_not_have_account_check.dart';
import 'package:social_network_test/widgets/rounded_button.dart';
import 'package:social_network_test/widgets/rounded_input_field.dart';
import 'package:social_network_test/widgets/rounded_password_field.dart';
import 'or_divider.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Email",
                controller: emailTextFieldController,
                validator: (val) => val.isEmpty ? "Enter email" : null,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                controller: passwordTextFieldController,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "LOGIN",
                press: () async {
                  if (_formKey.currentState.validate()) {
                      email = emailTextFieldController.text;
                      password = passwordTextFieldController.text;
                    loginViewModelInstance.signInWithEmailAndPassword(
                        email, password, context);
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              DoNotHaveAccountCheck(
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: ()  {
                       loginViewModelInstance.signInWithFacebook(context);
                    },
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {
                       loginViewModelInstance.signInWithGoogle(context);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
