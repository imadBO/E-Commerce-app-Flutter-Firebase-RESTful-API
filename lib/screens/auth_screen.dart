import 'package:flutter/material.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/Auth/auth_form.dart';
import 'package:shopy/widgets/Auth/wave_clipper.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(color: kWhite.withOpacity(0.6)),
            Align(
              alignment: Alignment.topCenter,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: deviceHeight(context) * 0.52,
                  width: deviceWidth(context),
                  color: kGreyishPink.withOpacity(0.7),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: deviceHeight(context) * 0.5,
                  width: deviceWidth(context),
                  padding: const EdgeInsets.only(top: 15),
                  color: kRusticRed,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: kGreyishPink,
                        size: 50,
                      ),
                      Text(
                        'Life is hard enough already. Let\'s make it a little bit easier!',
                        style: kGeneralTxtStyle.copyWith(
                          color: kGreyishPink,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AuthForm(
                width: deviceWidth(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
