import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/auth_provider.dart';
import 'package:shopy/providers/bottom_nav_bar_provider.dart';
import 'package:shopy/utils/constants.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Center(
            child: CircleAvatar(
              radius: 30,
              child: Icon(Icons.manage_accounts),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'email@email.com',
              style: kGeneralTxtStyle.copyWith(fontSize: 20),
            ),
          ),
          const Divider(indent: 20, endIndent: 20, height: 20),
          AccountItem(
            icon: Icons.create_outlined,
            label: 'Change password',
            onPressed: () {},
          ),
          const Divider(indent: 20, endIndent: 20, height: 5),
          AccountItem(
            icon: Icons.logout_outlined,
            label: 'Log out',
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logOut();
              Provider.of<NavBarProvider>(context, listen: false).resetIndex();
            },
          ),
        ],
      ),
    );
  }
}

class AccountItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function()? onPressed;
  const AccountItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(icon),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                label,
                style: kGeneralTxtStyle.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
