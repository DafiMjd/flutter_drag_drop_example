import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  const ErrorAlertDialog({
    Key? key,
    required this.error,
  }) : super(key: key);

  final Object error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text("$error"),
      actions: [
        TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(),
            child: const Text("okay"))
      ],
    );
  }

  static Future<dynamic> fileInvalid(String message, BuildContext context,) {
    
    return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              error: message,
            );
          });
  }
}