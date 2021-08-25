import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';

import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../authentication_provider.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var emailcontroller = TextEditingController();
    var namecontroller = TextEditingController();
    var phonecontroller = TextEditingController();
    var passcontroller = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Регистрация",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Ваша почта",
              onChanged: (value) {},
              controller: emailcontroller,
              textInputAction: TextInputAction.next,
            ),
            RoundedInputField(
              hintText: "Ваши Имя и Фамилия",
              onChanged: (value) {},
              controller: namecontroller,
              textInputAction: TextInputAction.next,
            ),
            RoundedInputField(
              hintText: "Ваш телефон",
              onChanged: (value) {},
              controller: phonecontroller,
              textInputAction: TextInputAction.next,
            ),
            RoundedPasswordField(
              onChanged: (value) {},
              controller: passcontroller,
            ),
            RoundedButton(
              text: "Зарегистрироваться",
              press: () {
                if (emailcontroller.text == '' ||
                    passcontroller.text == '' ||
                    namecontroller.text == '' ||
                    phonecontroller.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Не оставляйте пустых полей"),
                  ));
                } else
                  AuthenticationProvider(auth).signUp(
                      emailcontroller.text,
                      passcontroller.text,
                      namecontroller.text,
                      phonecontroller.text);
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
          ],
        ),
      ),
    );
  }
}
