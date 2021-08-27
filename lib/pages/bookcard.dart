import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_auth/pages/single_news_page.dart';
import 'package:flutter_auth/utils/helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BookInformation extends StatefulWidget {
  List<Map<dynamic, dynamic>> lists = [];
  BookInformation(values) {
    this.lists = values;
  }
  @override
  _BookInformation createState() => _BookInformation();
}

class _BookInformation extends State<BookInformation> {
  TextEditingController editingController = TextEditingController();

  List<Map<dynamic, dynamic>> items = [];
  final scrollDirection = Axis.vertical;
  AutoScrollController controller;
  @override
  void initState() {
    items.addAll(widget.lists);

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);

    super.initState();
  }

  void filterSearchResults(String query) {
    //items = widget.lists;
    List<Map<dynamic, dynamic>> temp = [];
    temp.addAll(items);
    if (query.isNotEmpty) {
      List<Map<dynamic, dynamic>> dummyListData = [];
      temp.forEach((items) {
        if (items['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(items);
          //print(items);
          print(dummyListData);
        }
      });
      setState(() {
        items.clear();
        items = dummyListData;
        print(items);
      });
      return;
    } else {
      setState(() {
        items.clear();
        //print(widget.lists);
        items.addAll(widget.lists);
      });
    }
    print(widget.lists);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TextField(
        onChanged: (value) {
          filterSearchResults(value);
        },
        controller: editingController,
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
      Container(
        child: NewWidget(
            scrollDirection: scrollDirection,
            controller: controller,
            items: items),
      )
    ]));
  }

  Future _scrollToIndex() async {
    await controller.scrollToIndex(6, preferPosition: AutoScrollPosition.begin);
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key key,
    @required this.scrollDirection,
    @required this.controller,
    @required this.items,
  }) : super(key: key);

  final Axis scrollDirection;
  final AutoScrollController controller;
  final List<Map> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: scrollDirection,
        controller: controller,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Helper.nextScreen(context, SingleNewsPage(items[index]));
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
                        image: items[index]["image"] != null
                            ? NetworkImage(items[index]["image"])
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
                          items[index]['name'],
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
                          items[index]['author'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          items[index]["description"],
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
        });
  }
}
