import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/utils/notification_service.dart';
import 'package:flutter_auth/utils/static_data.dart';

import 'package:flutter_auth/pages/bookcard.dart';
import 'package:flutter_auth/pages/addbookpage.dart';

class Home extends StatelessWidget {
  //final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Widget addFloatButton(context, snapshot) {
    if (snapshot.data['role'] == 'bibl' || snapshot.data['role'] == 'admin') {
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
                  builder: (_) => MyApp(),
                ));
            //sendAndRetrieveMessage();
            print("Функция добавлени для буккросинга");
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
            body: BookInformation(),
            floatingActionButton: addFloatButton(context, snapshot),
          );
        });
  }
}
