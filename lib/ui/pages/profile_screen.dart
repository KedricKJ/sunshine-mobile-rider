import 'package:flutter/material.dart';
import 'package:sunshine_laundry_driver_app/ui/widgets/header_widget.dart';
import 'package:sunshine_laundry_driver_app/utils/colors.dart';
import 'package:sunshine_laundry_driver_app/utils/styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ProfileScreen extends StatelessWidget {
  static final routeName = "profile-screen";

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: mQ.width,
            height: mQ.height,
          ),
          NoLogoHeaderWidget(height: mQ.height * 0.5),
          Positioned(
              top: mQ.height * 0.18,
              child: Container(
                height: mQ.height,
                width: mQ.width,
                child: ListView(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffd6d6d6),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x29000000),
                              offset: Offset(0, 5),
                              blurRadius: 6,
                              spreadRadius: 0)
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "User Name",
                      textAlign: TextAlign.center,
                      style: CustomStyles.cardBoldDarkTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
          Positioned(
              top: mQ.height * 0.05,
              child: Container(
                height: mQ.height,
                width: mQ.width,
                child: ListView(
                  children: <Widget>[
                    Text(
                      "Profile Info",
                      textAlign: TextAlign.center,
                      style: CustomStyles.cardBoldTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
