import 'package:flutter/material.dart';
import 'package:sunshine_laundry_driver_app/utils/colors.dart';
import 'package:sunshine_laundry_driver_app/utils/constants.dart';

class HeaderWidget extends StatelessWidget {
  final double height;
  const HeaderWidget({Key key, this.height}) : super( key: key);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderCustomClipper(),
      child: Container(
        height: height,
        color: Color(ThemeColors.themePrimaryColor),
        child: Center(
          child: Container(
            width: 200,
            child: Image.asset(
              Constants.logo,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}

class NoLogoHeaderWidget extends StatelessWidget {
  final double height;
  const NoLogoHeaderWidget({Key key, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderCustomClipper(),
      child: Container(
        height: height,
        color: Color(ThemeColors.themePrimaryColor),
        child: Center(
          child: Container(
            width: 200,
          ),
        ),
      ),
    );
  }
}

class HeaderCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 150);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}