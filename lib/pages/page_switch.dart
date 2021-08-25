import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_auth/pages/home.dart';

import 'package:flutter_auth/pages/user_settings.dart';
import 'package:flutter_auth/widgets/bottom_bar.dart';
import 'package:flutter_auth/widgets/nu_appbar.dart';
import 'package:flutter_auth/pages/scanner.dart';
import 'package:flutter_auth/pages/requestpage.dart';

class PageSwitch extends StatefulWidget {
  @override
  _PageSwitchState createState() => _PageSwitchState();
}

class _PageSwitchState extends State<PageSwitch> {
  int currentIndex = 0;

  // Obtain a list of the available cameras on the device.

  void changeCurrentIndex(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }

  List getBottomBar(context, snapshot) {
    if (snapshot.data['role'] == 'user') {
      return [
        //HomeBookCross(),
        Home(),
        RequestInformation(s: snapshot.data['role']),
        CameraAppTest(),
        UserSettings(),
      ];
    } else {
      return [
        Home(),
        RequestInformation(s: snapshot.data['role']),
        CameraAppTest(),
        UserSettings(),
      ];
    }
  }

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
          return Scaffold(
            bottomNavigationBar: BottomBar(
              changeIndex: changeCurrentIndex,
              currentIndex: currentIndex,
            ),
            body: SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NuAppbar(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: getBottomBar(context, snapshot)[currentIndex],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
