import 'package:flutter/material.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/utils/input_validation.dart';
import 'package:shopy/widgets/Auth/auth_button.dart';
import 'package:shopy/widgets/input_field.dart';

enum ScreenMode {
  login,
  singup,
}

class AuthForm extends StatefulWidget {
  final double width;
  const AuthForm({
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  ScreenMode mode = ScreenMode.login;
  Map<String, dynamic> formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
      width: mode == ScreenMode.login ? widget.width * 0.9 : widget.width,
      decoration: BoxDecoration(
        borderRadius: mode == ScreenMode.login
            ? const BorderRadius.all(Radius.circular(10))
            : null,
      ),
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: mode == ScreenMode.login ? false : true,
                child: InputField(
                  title: 'Full name',
                  inputType: TextInputType.name,
                  action: TextInputAction.next,
                  onSaved: (val) {
                    if (mode == ScreenMode.singup) {
                      formData['name'] = val;
                    }
                  },
                  validator: nameVlidator,
                ),
              ),
              InputField(
                title: 'E-mail',
                inputType: TextInputType.emailAddress,
                action: TextInputAction.next,
                onSaved: (val) {
                  formData['email'] = val;
                },
                validator: emailValidator,
              ),
              InputField(
                title: 'Password',
                obscure: true,
                action: mode == ScreenMode.singup
                    ? TextInputAction.next
                    : TextInputAction.done,
                onSaved: (val) {
                  formData['password'] = val;
                },
                validator: passwordValidator,
              ),
              Visibility(
                visible: mode == ScreenMode.login ? false : true,
                child: InputField(
                  title: 'Confirm password',
                  obscure: true,
                  action: TextInputAction.done,
                  onSaved: (val) {
                    if (mode == ScreenMode.singup) {
                      formData['confirmation'] = val;
                    }
                  },
                  validator: (val) {
                    return isIdentical(formData['password'], val);
                  },
                ),
              ),
              const SizedBox(height: 10),
              AuthenticateButton(mode: mode, formKey: _formKey, data: formData),
              TextButton(
                child: mode == ScreenMode.login
                    ? const Text('Sign up')
                    : const Text('Log in'),
                style: TextButton.styleFrom(
                  primary: kRusticRed,
                  textStyle: kGeneralTxtStyle,
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  setState(() {
                    if (mode == ScreenMode.login) {
                      mode = ScreenMode.singup;
                      _formKey.currentState!.reset();
                    } else {
                      mode = ScreenMode.login;
                      _formKey.currentState!.reset();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
