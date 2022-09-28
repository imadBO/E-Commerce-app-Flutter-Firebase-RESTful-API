import 'package:flutter/material.dart';
import 'package:shopy/utils/constants.dart';

class AddProductIcon extends StatelessWidget {
  const AddProductIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, kAddProductRoute);
      },
      icon: const Icon(Icons.add),
    );
  }
}
