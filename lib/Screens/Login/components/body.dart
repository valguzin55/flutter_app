import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/authentication_provider.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/main.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_auth/main1.dart';

class Body extends StatelessWidget {
  Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var passcontroller = TextEditingController();
    var emailcontroller = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    Future<bool> _login(String email, String password) async {
      //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      try {
        await _auth.signInWithEmailAndPassword(
            email: emailcontroller.text, password: passcontroller.text);
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

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
              controller: emailcontroller,
            ),
            RoundedPasswordField(
              onChanged: (value) {},
              controller: passcontroller,
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                AuthenticationProvider(_auth)
                    .signIn(emailcontroller.text, passcontroller.text);
                //await _login(emailcontroller.text, passcontroller.text);
              },
              //Lord55jLord55j
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
