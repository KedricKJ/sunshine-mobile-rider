import 'package:flutter/material.dart';

class CommonFunctions{
  BuildContext _context ;

  CommonFunctions(BuildContext context){
    _context = context;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}