import 'package:flutter/material.dart';

void customSnakBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(content),
      action: null,
    ),
  );
}
