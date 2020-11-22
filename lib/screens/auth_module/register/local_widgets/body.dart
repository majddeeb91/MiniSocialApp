import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'package:social_network_test/screens/auth_module/login/login_screen.dart';
import 'package:social_network_test/screens/home_module/news_feed/news_feed_screen.dart';
import 'package:social_network_test/widgets/background.dart';
import 'package:social_network_test/widgets/rounded_button.dart';
import 'package:social_network_test/widgets/rounded_input_field.dart';
import 'package:social_network_test/widgets/rounded_password_field.dart';
import '../register_viewmodel.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String username = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  String password = "";
  final _formKey = GlobalKey<FormState>();

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
                "Register",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.35,
              ),
              RoundedInputField(
                hintText: "Email",
                validator: (val) => val.isEmpty ? "Enter email" : null,
                onChanged: (value) async {
                  setState(() => email = value);
                },
              ),
              RoundedInputField(
                hintText: "First name",
                validator: (val) => val.isEmpty ? "Enter first name" : null,
                onChanged: (value) async {
                  setState(() => firstName = value);
                },
              ),
              RoundedInputField(
                hintText: "Last name",
                validator: (val) => val.isEmpty ? "Enter last name" : null,
                onChanged: (value) async {
                  setState(() => lastName = value);
                },
              ),
              RoundedPasswordField(
                onChanged: (value) async {
                  setState(() => password = value);
                },
              ),
              RoundedButton(
                text: "Register",
                press: () async{
                  if (_formKey.currentState.validate()) {
                   await registerViewModelInstance
                        .register(firstName, lastName, email, password, context).then((value) => {

                     //    if (value is FireStoreResponseData){
                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NewsFeedScreen()), (route) => false)
                     


                   });
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
