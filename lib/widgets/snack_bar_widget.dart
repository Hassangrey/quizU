import 'package:flutter/material.dart';
import 'package:quiz_app/util/constants.dart';

void showActionSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    backgroundColor: COLOR_BROWN.withOpacity(0.8),
    padding: const EdgeInsets.all(12),
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(seconds: 4),
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
