import 'package:flutter/material.dart';

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height -
      MediaQuery.of(context).viewPadding.top -
      kToolbarHeight;
}

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
