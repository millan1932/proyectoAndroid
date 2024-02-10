import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonMethods
{
  displaySnackBar(String title, BuildContext context)
  {
    var snackBar = SnackBar(content: Text(title));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}