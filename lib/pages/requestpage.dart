import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/pages/single_news_page.dart';
import 'package:flutter_auth/utils/helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_auth/pages/singlerequest.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class RequestInformation extends StatefulWidget {
  String role;
  Stream<QuerySnapshot> requestStream;
  RequestInformation({String s}) {
    this.role = s;
    if (s != 'user')
      requestStream =
          FirebaseFirestore.instance.collection('requests').snapshots();
    else
      requestStream = FirebaseFirestore.instance
          .collection('requests')
          .where('login', isEqualTo: auth.currentUser.email)
          .snapshots();
  }
  @override
  _RequestInformation createState() => _RequestInformation();
}

class _RequestInformation extends State<RequestInformation> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.requestStream,
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
        print("work");
        if (snapshot.data.docs.length == 0) {
          return Material(
            child: Center(
              child: Text("У вас нет взятых книг"),
            ),
          );
        }
        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> _data =
                document.data() as Map<String, dynamic>;
            print(_data);
            return GestureDetector(
              onTap: () {
                Helper.nextScreen(context, SingleRequest(_data, widget.role));
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(233, 233, 233, 1),
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  children: [
                    Container(
                      height: ScreenUtil().setHeight(175.0),
                      width: ScreenUtil().setWidth(125.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(233, 233, 233, 1),
                        ),
                        image: DecorationImage(
                          image: _data["image"] != null
                              ? NetworkImage(_data["image"])
                              : AssetImage('assets/images/noimage.jpg'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _data['nameuser'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            _data['namebook'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            DateTime.now().toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color.fromRGBO(139, 144, 165, 1),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            _data['state'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
