import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/auth_provider.dart';

import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/Auth/auth_form.dart';
import 'package:shopy/widgets/error_dialog.dart';

class AuthenticateButton extends StatefulWidget {
  final ScreenMode mode;
  final GlobalKey<FormState> formKey;
  final Map data;
  const AuthenticateButton({
    Key? key,
    required this.mode,
    required this.formKey,
    required this.data,
  }) : super(key: key);

  @override
  State<AuthenticateButton> createState() => _AuthenticateButtonState();
}

class _AuthenticateButtonState extends State<AuthenticateButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : widget.mode == ScreenMode.login
              ? const Text('Log In')
              : const Text('Sign up'),
      style: ElevatedButton.styleFrom(
        primary: kGreyishPink,
        onPrimary: kRusticRed,
        textStyle: kGeneralTxtStyle,
        fixedSize: const Size(200, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () async {
        widget.formKey.currentState!.save();
        if (widget.formKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });

          final provider = Provider.of<AuthProvider>(context, listen: false);

          try {
            if (widget.mode == ScreenMode.singup) {
              await provider.signup(widget.data);
            } else {
              await provider.login(widget.data);
            }
            widget.formKey.currentState!.reset();
          } catch (error) {
            showDialog(
                context: context,
                builder: (_) {
                  return ErrorDialog(
                    error: error.toString(),
                  );
                });
          }

          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }
}
