import 'package:flutter/material.dart';
import 'package:shopy/utils/constants.dart';

class DialogButton extends StatelessWidget {
  final BuildContext ctx;
  final String title;
  final bool returnValue;
  const DialogButton({
    required this.ctx,
    required this.title,
    required this.returnValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(ctx, returnValue);
      },
      child: Text(title),
      style: TextButton.styleFrom(
        primary: kBlack,
        backgroundColor: kBlack1,
        textStyle: kGeneralTxtStyle,
      ),
    );
  }
}
