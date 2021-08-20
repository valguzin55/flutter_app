import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/pages/single_news_page.dart';
import 'package:flutter_auth/utils/helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final Stream<QuerySnapshot> _booksStream =
    FirebaseFirestore.instance.collection('books').snapshots();

class BookInformation extends StatefulWidget {
  @override
  _BookInformation createState() => _BookInformation();
}

class _BookInformation extends State<BookInformation> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _booksStream,
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

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> _data =
                document.data() as Map<String, dynamic>;
            print(_data);
            return GestureDetector(
              onTap: () {
                Helper.nextScreen(context, SingleNewsPage(_data));
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
                            _data['name'],
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
                            _data['author'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            _data["description"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color.fromRGBO(139, 144, 165, 1),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [],
                          )
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
