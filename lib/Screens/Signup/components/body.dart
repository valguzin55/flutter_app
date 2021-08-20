import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../authentication_provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Future<bool> _register(String email, String password) async {
      //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print("pass weak");
          return false;
        } else {
          print("another error");
          return false;
        }
      }
    }

    var emailcontroller = TextEditingController();
    var namecontroller = TextEditingController();
    var passcontroller = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
              controller: emailcontroller,
            ),
            RoundedInputField(
              hintText: "Your name",
              onChanged: (value) {},
              controller: namecontroller,
            ),
            RoundedPasswordField(
              onChanged: (value) {},
              controller: passcontroller,
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                AuthenticationProvider(auth).signUp(emailcontroller.text,
                    passcontroller.text, namecontroller.text);

                // print(succesAuth);
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
