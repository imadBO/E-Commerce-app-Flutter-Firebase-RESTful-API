import 'package:flutter/material.dart';
import 'package:shopy/utils/constants.dart';

class InputField extends StatelessWidget {
  final TextInputAction? action;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? inputType;
  final String title;
  final int? maxLines;
  final String? initialVal;
  final bool obscure;
  final void Function(String?)? onSaved;
  final void Function(String)? onEditingComplete;
  final String? Function(String?)? validator;

  const InputField({
    required this.title,
    this.action,
    this.controller,
    this.focusNode,
    this.inputType,
    this.maxLines = 1,
    this.initialVal,
    this.obscure = false,
    required this.onSaved,
    this.onEditingComplete,
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        textInputAction: action,
        keyboardType: inputType,
        initialValue: initialVal,
        obscureText: obscure,
        decoration: InputDecoration(
          label: Text(title),
          labelStyle: kGeneralTxtStyle.copyWith(fontSize: 16),
          floatingLabelStyle: kGeneralTxtStyle.copyWith(
            fontSize: 20,
            color: kGreyishPink,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kGrey02),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kGrey02),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          errorStyle: kGeneralTxtStyle.copyWith(fontSize: 13),
          errorMaxLines: 2,
          filled: true,
          fillColor: kGrey02,
        ),
        validator: validator,
        onSaved: onSaved,
        onFieldSubmitted: onEditingComplete,
      ),
    );
  }
}
