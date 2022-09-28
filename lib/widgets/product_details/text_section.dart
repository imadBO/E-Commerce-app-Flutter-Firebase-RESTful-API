import 'package:flutter/material.dart';
import 'package:shopy/utils/constants.dart';

class TextSection extends StatelessWidget {
  final String title;
  final String content;
  const TextSection({required this.title, required this.content, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 130,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: const BoxDecoration(
            color: kRusticRed,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          ),
          child: Text(
            title,
            style: kGeneralTxtStyle.copyWith(fontSize: 18, color: kWhite),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            content,
            style: kGeneralTxtStyle.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
