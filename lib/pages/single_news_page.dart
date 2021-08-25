import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_auth/widgets/single_news_header.dart';

class SingleNewsPage extends StatelessWidget {
  Map<String, dynamic> data;
  SingleNewsPage(
    Map<String, dynamic> n,
  ) {
    data = n;
  }

  deleteBook() async {
    final collection = FirebaseFirestore.instance.collection('books');
    QuerySnapshot querySnap =
        await collection.where("isbn", isEqualTo: data['isbn']).get();
    collection
        .doc(querySnap.docs[0].id) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => print('Deleted'))
        .catchError((error) => print('Delete failed: $error'));
  }

  Widget delButton(context, snapshot) {
    if (snapshot.data['role'] != 'user') {
      return ElevatedButton(
        onPressed: () {
          deleteBook();
          Navigator.pop(context);
        },
        child: Text(
          "Удалить запись",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
      );
    } else {
      return Text(":)");
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              toolbarHeight: 0.0,
              elevation: 0.0,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleNewsHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              data['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              data['author'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              height: ScreenUtil().setHeight(200),
                              width: ScreenUtil().setWidth(200),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(233, 233, 233, 1),
                                ),
                                image: DecorationImage(
                                  image: this.data["image"] != null
                                      ? NetworkImage(this.data["image"])
                                      : AssetImage('assets/images/noimage.jpg'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              data['publisher'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              data['description'],
                              style: TextStyle(
                                height: 1.7,
                                color: Color.fromRGBO(139, 144, 165, 1),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    "isbn:  ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Text(
                                    data['isbn'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            delButton(context, snapshot),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
