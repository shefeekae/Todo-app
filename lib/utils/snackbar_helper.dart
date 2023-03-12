import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, Color backgroundColor,
    {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: backgroundColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
