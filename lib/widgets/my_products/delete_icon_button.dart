import 'package:flutter/material.dart';
import 'package:shopy/utils/constants.dart';

class DeleteIconButton extends StatelessWidget {
  final void Function() onPressed;
  const DeleteIconButton({
    required this.onPressed,
    Key? key,
    required this.product,
  }) : super(key: key);

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog<bool>(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Are you sure you want to remove this item?'),
                actions: [
                  TextButton(
                    onPressed: onPressed,
                    child: const Text('Yes'),
                    style: TextButton.styleFrom(
                      primary: kBlack,
                      backgroundColor: kBlack1,
                      textStyle: kGeneralTxtStyle,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No'),
                    style: TextButton.styleFrom(
                      primary: kBlack,
                      backgroundColor: kBlack1,
                      textStyle: kGeneralTxtStyle,
                    ),
                  ),
                ],
              );
            });
      },
      icon: const Icon(Icons.delete, color: kDeepOrange),
    );
  }
}
