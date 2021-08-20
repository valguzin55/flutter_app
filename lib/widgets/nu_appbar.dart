import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_auth/pages/notifications.dart';
import 'package:flutter_auth/utils/helper.dart';

class NuAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(50.0),
      padding: EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(169, 176, 185, 0.42),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              "Библиотека",
              style: GoogleFonts.ptSans(
                fontSize: 20.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Helper.nextScreen(context, Notifications());
            },
            child: Icon(
              FlutterIcons.bell_sli,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }
}
