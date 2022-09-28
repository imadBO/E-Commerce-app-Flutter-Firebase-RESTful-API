import 'package:flutter/material.dart';
import 'package:shopy/utils/constants.dart';

class CustomNavigationBar extends StatelessWidget {
  final int index;
  final Function(int) onUpdate;
  const CustomNavigationBar({
    required this.index,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: kGreyishPink, width: 0.8),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: kWhite,
        selectedLabelStyle: kGeneralTxtStyle.copyWith(fontSize: 13),
        selectedItemColor: kRusticRed,
        unselectedItemColor: kGreyishPink,
        enableFeedback: true,
        currentIndex: index,
        onTap: (index) {
          onUpdate(index);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Shop',
            icon: index == 0
                ? const Icon(Icons.shopping_cart)
                : const Icon(Icons.shopping_cart_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Orders',
            icon: index == 1
                ? const Icon(Icons.shopify)
                : const Icon(Icons.shopify),
          ),
          BottomNavigationBarItem(
            label: 'My products',
            icon: index == 2
                ? const Icon(Icons.space_dashboard)
                : const Icon(Icons.space_dashboard_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: index == 3
                ? const Icon(Icons.manage_accounts)
                : const Icon(Icons.manage_accounts_outlined),
          ),
        ],
      ),
    );
  }
}
