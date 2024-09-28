import 'package:flutter/material.dart';

void showSnackBar(
    {required String message,
    bool isError = false,
    required BuildContext context}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isError ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
