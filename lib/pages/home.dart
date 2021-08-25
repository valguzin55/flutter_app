import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_auth/pages/bookcard.dart';
import 'package:flutter_auth/pages/addbookpage.dart';

final auth = FirebaseAuth.instance;

class Home extends StatelessWidget {
  //final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Widget addFloatButton(context, snapshot) {
    if (snapshot.data['role'] == 'bibl' || snapshot.data['role'] == 'admin1') {
      return FloatingActionButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddWidget(),
                ));
          },
          child: const Icon(Icons.book),
          backgroundColor: Colors.red.shade300);
    } else {
      return FloatingActionButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddWidget(),
                ));
          },
          child: const Icon(Icons.book),
          backgroundColor: Colors.red.shade300);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            body: BookInformation(auth),
            floatingActionButton: addFloatButton(context, snapshot),
          );
        });
  }
}
