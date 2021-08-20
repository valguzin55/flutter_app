import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/pages/single_news_page.dart';
import 'package:flutter_auth/utils/helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_auth/pages/singlerequest.dart';

final Stream<QuerySnapshot> _crossStream =
    FirebaseFirestore.instance.collection('books').snapshots();

class HomeBookCross extends StatefulWidget {
  @override
  _HomeBookCross createState() => _HomeBookCross();
}

class _HomeBookCross extends State<HomeBookCross> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _crossStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ListView(children: [Text("poka pusto")]);
      },
    );
  }
}
