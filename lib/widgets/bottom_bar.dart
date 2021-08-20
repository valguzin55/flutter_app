import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_auth/utils/constants.dart';

class BottomBar extends StatelessWidget {
  final Function changeIndex;
  final int currentIndex;
  BottomBar({this.changeIndex, this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: this.currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 24,
      unselectedIconTheme: IconThemeData(
        color: Color.fromRGBO(202, 205, 219, 1),
      ),
      selectedIconTheme: IconThemeData(
        color: Constants.primaryColor,
      ),
      onTap: (index) {
        changeIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          label: "",
          icon: Icon(FlutterIcons.book_ant),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(
            FlutterIcons.bookmark_fea,
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(FlutterIcons.camera_ent),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(FlutterIcons.menu_ent),
        ),
      ],
    );
  }
}
