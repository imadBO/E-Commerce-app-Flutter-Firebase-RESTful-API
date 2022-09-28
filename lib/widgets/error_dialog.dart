import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String error;
  const ErrorDialog({
    this.error = 'Something went wrong, try again',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('An error has occurred !'),
      content: Text(error),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        )
      ],
    );
  }
}
