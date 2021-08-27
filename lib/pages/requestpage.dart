import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/utils/helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_auth/pages/singlerequest.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class RequestInformation extends StatefulWidget {
  String role;
  Stream<QuerySnapshot> requestStream;
  Stream<QuerySnapshot> requestStream1;
  Stream<QuerySnapshot> index0;
  Stream<QuerySnapshot> index1;
  Stream<QuerySnapshot> index2;
  Stream<QuerySnapshot> index3;
  Stream<QuerySnapshot> index4;
  Stream<QuerySnapshot> ind0;
  Stream<QuerySnapshot> ind1;
  Stream<QuerySnapshot> ind2;
  Stream<QuerySnapshot> ind3;
  Stream<QuerySnapshot> ind4;
  Stream<QuerySnapshot> rs;
  Stream<QuerySnapshot> rs1;
  RequestInformation({String s}) {
    this.role = s;

    requestStream = FirebaseFirestore.instance
        .collection('requests')
        .where('owner', isEqualTo: auth.currentUser.email)
        .orderBy("dategive")
        .snapshots();
    ind0 = FirebaseFirestore.instance
        .collection('requests')
        .where('owner', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "создана")
        .orderBy("dategive")
        .snapshots();
    ind1 = FirebaseFirestore.instance
        .collection('requests')
        .where('owner', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "подтверждена")
        .orderBy("dategive")
        .snapshots();
    ind2 = FirebaseFirestore.instance
        .collection('requests')
        .where('owner', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "отклонена")
        .orderBy("dategive")
        .snapshots();
    ind3 = FirebaseFirestore.instance
        .collection('requests')
        .where('owner', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "возврат")
        .orderBy("dategive")
        .snapshots();
    ind4 = FirebaseFirestore.instance
        .collection('requests')
        .where('owner', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "закончена")
        .orderBy("dategive")
        .snapshots();
    requestStream1 = FirebaseFirestore.instance
        .collection('requests')
        .where('login', isEqualTo: auth.currentUser.email)
        .orderBy("dategive")
        .snapshots();
    index0 = FirebaseFirestore.instance
        .collection('requests')
        .where('login', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "создана")
        .orderBy("dategive")
        .snapshots();
    index1 = FirebaseFirestore.instance
        .collection('requests')
        .where('login', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "подтверждена")
        .orderBy("dategive")
        .snapshots();
    index2 = FirebaseFirestore.instance
        .collection('requests')
        .where('login', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "отклонена")
        .orderBy("dategive")
        .snapshots();
    index3 = FirebaseFirestore.instance
        .collection('requests')
        .where('login', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "возврат")
        .orderBy("dategive")
        .snapshots();
    index4 = FirebaseFirestore.instance
        .collection('requests')
        .where('login', isEqualTo: auth.currentUser.email)
        .where('state', isEqualTo: "закончена")
        .orderBy("dategive")
        .snapshots();

    rs = requestStream1;
    rs1 = requestStream;
  }
  @override
  _RequestInformation createState() => _RequestInformation();
}

class Tech {
  String label;
  Color color;
  Tech(this.label, this.color);
}

class _RequestInformation extends State<RequestInformation> {
  int selectedIndex;
  int selectedIndex1;
  List<Tech> _chipsList = [
    Tech("Все", Colors.white),
    Tech("Создана", Colors.white),
    Tech("Подтверждена", Colors.white),
    Tech("Отклонена", Colors.white),
    Tech("Возврат", Colors.white),
    Tech("Закончена", Colors.white),
  ];
  List<Tech> _chipsList1 = [
    Tech("Все", Colors.white),
    Tech("Создана", Colors.white),
    Tech("Подтверждена", Colors.white),
    Tech("Отклонена", Colors.white),
    Tech("Возврат", Colors.white),
    Tech("Закончена", Colors.white),
  ];
  List<Widget> techChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          label: Text(_chipsList[i].label),
          labelStyle: TextStyle(color: Colors.deepOrange),
          backgroundColor: _chipsList[i].color,
          selected: selectedIndex == i,
          onSelected: (bool value) {
            setState(() {
              selectedIndex = i;
              if (i == 0) {
                widget.rs = widget.requestStream1;
              }
              if (i == 1) {
                widget.rs = widget.index0;
              }
              if (i == 2) {
                widget.rs = widget.index1;
              }
              if (i == 3) {
                widget.rs = widget.index2;
              }
              if (i == 4) {
                widget.rs = widget.index3;
              }
              if (i == 5) {
                widget.rs = widget.index4;
              }
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  List<Widget> techChips1() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList1.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          label: Text(_chipsList1[i].label),
          labelStyle: TextStyle(color: Colors.deepOrange),
          backgroundColor: _chipsList1[i].color,
          selected: selectedIndex1 == i,
          onSelected: (bool value) {
            setState(() {
              selectedIndex1 = i;
              if (i == 0) {
                widget.rs1 = widget.requestStream;
              }
              if (i == 1) {
                widget.rs1 = widget.ind0;
              }
              if (i == 2) {
                widget.rs1 = widget.ind1;
              }
              if (i == 3) {
                widget.rs1 = widget.ind2;
              }
              if (i == 4) {
                widget.rs1 = widget.ind3;
              }
              if (i == 5) {
                widget.rs1 = widget.ind4;
              }
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                  icon: Icon(
                Icons.task_rounded,
                color: Colors.black54,
              )),
              Tab(
                  icon: Icon(
                Icons.get_app,
                color: Colors.black54,
              )),
            ],
          ),
          toolbarHeight: 50,
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: widget.rs,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                if (snapshot.data.docs.length == 0) {
                  return Material(
                    child: Center(
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 6,
                            direction: Axis.horizontal,
                            children: techChips(),
                          ),
                          Text("У вас нет взятых книг"),
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 6,
                        direction: Axis.horizontal,
                        children: techChips(),
                      ),
                      Expanded(
                        child: ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> _data =
                                document.data() as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () {
                                Helper.nextScreen(
                                    context, SingleRequest(_data, widget.role));
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
                                          color:
                                              Color.fromRGBO(233, 233, 233, 1),
                                        ),
                                        image: DecorationImage(
                                          image: _data["image"] != null
                                              ? NetworkImage(_data["image"])
                                              : AssetImage(
                                                  'assets/images/noimage.jpg'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
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
                                              color: Color.fromRGBO(
                                                  139, 144, 165, 1),
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
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: widget.rs1,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    children: [
                      Wrap(
                        spacing: 6,
                        direction: Axis.horizontal,
                        children: techChips1(),
                      ),
                      Text('Something went wrong'),
                    ],
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.data.docs.length == 0) {
                  return Material(
                    child: Center(
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 6,
                            direction: Axis.horizontal,
                            children: techChips1(),
                          ),
                          Text("У вас нет заявок на книги"),
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 6,
                        direction: Axis.horizontal,
                        children: techChips1(),
                      ),
                      Expanded(
                        child: ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> _data =
                                document.data() as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () {
                                Helper.nextScreen(
                                    context, SingleRequest(_data, "bookcross"));
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
                                          color:
                                              Color.fromRGBO(233, 233, 233, 1),
                                        ),
                                        image: DecorationImage(
                                          image: _data["image"] != null
                                              ? NetworkImage(_data["image"])
                                              : AssetImage(
                                                  'assets/images/noimage.jpg'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
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
                                              color: Color.fromRGBO(
                                                  139, 144, 165, 1),
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
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
