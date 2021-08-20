import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/utils/constants.dart';
import 'package:flutter_auth/utils/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../authentication_provider.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettings createState() => _UserSettings();
}

class _UserSettings extends State<UserSettings> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String user = FirebaseAuth.instance.currentUser.uid;
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Имя   ',
                              style: TextStyle(
                                  color: Colors.red.shade300, fontSize: 30),
                              children: <TextSpan>[
                                TextSpan(
                                    text: auth.currentUser.displayName,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))
                              ]),
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Почта   ',
                              style: TextStyle(
                                  color: Colors.red.shade300, fontSize: 30),
                              children: <TextSpan>[
                                TextSpan(
                                    text: auth.currentUser.email,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))
                              ]),
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Права   ',
                              style: TextStyle(
                                  color: Colors.red.shade300, fontSize: 30),
                              children: <TextSpan>[
                                TextSpan(
                                    text: snapshot.data['role'] as String,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))
                              ]),
                        ),
                        Text("Выйти"),
                        RoundedButton(
                          text: "LOGOUT",
                          press: () {
                            AuthenticationProvider(auth).signOut();
                            // print(succesAuth);
                          },
                        ),
                      ])));
        });
  }
}
