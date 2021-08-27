import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_auth/pages/bookcard.dart';
import 'package:flutter_auth/pages/addbookpage.dart';

final auth = FirebaseAuth.instance;

class Home extends StatelessWidget {
  //final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Widget addFloatButton(context) {
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
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('books')
                  .where("login", isEqualTo: snapshot.data['email'])
                  .orderBy("name")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.data.size == 0) {
                  return Material(
                    child: Center(
                      child: Text("Здесь будут ваши добавленные книги"),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  List<Map<dynamic, dynamic>> values = snapshot.data.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    return documentSnapshot.data() as Map<String, dynamic>;
                  }).toList();

                  return Scaffold(
                    resizeToAvoidBottomInset: false, // this is new

                    body: SingleChildScrollView(child: BookInformation(values)),
                    floatingActionButton: addFloatButton(context),
                  );
                }
                return null;
                //   return StreamBuilder<Object>(
                //     stream: null,
                //     builder: (context, snapshot) {
                //       return Scaffold(
                //         resizeToAvoidBottomInset: false, // this is new

                //         body: SingleChildScrollView(child: BookInformation(auth)),
                //         floatingActionButton: addFloatButton(context, snapshot),
                //       );
              });
        });
  }
}
