import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunshine_laundry_driver_app/utils/colors.dart';

class CustomStyles{
  static final smallTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Color(ThemeColors.themeMainTextColor),
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  );

  static final mediumTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Color(ThemeColors.themeMainTextColor),
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );

  static final smallLightTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.grey,
      fontSize: 10,
      fontFamily: 'Poppins',
    ),
  );

  static final normalTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Color(0xff303030),
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  );

  static final cardBoldTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );

  static final cardBoldDarkTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );

  static final cardBoldDarkTextStyle2 = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  );
}