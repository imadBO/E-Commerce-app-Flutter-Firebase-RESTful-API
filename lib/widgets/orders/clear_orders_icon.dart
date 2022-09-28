import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/orders_provider.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/error_dialog.dart';
import 'package:shopy/widgets/snackbar.dart';

class ClearOrdersIcon extends StatefulWidget {
  const ClearOrdersIcon({Key? key}) : super(key: key);

  @override
  State<ClearOrdersIcon> createState() => _ClearOrdersIconState();
}

class _ClearOrdersIconState extends State<ClearOrdersIcon> {
  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrdersProvider>(context);
    return Visibility(
      visible: provider.length != 0,
      child: IconButton(
        icon: inProgress
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: kBlack),
              )
            : const Icon(Icons.delete),
        iconSize: 28,
        tooltip: 'Show only favorites',
        padding: const EdgeInsets.only(bottom: 8),
        onPressed: () {
          showDialog<bool>(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Are you sure you want to clear orders?'),
                  actions: [
                    TextButton(
                      child: const Text('Yes'),
                      style: TextButton.styleFrom(
                        primary: kBlack,
                        backgroundColor: kBlack1,
                        textStyle: kGeneralTxtStyle,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          inProgress = true;
                        });
                        try {
                          await provider.clearOrders();
                          customSnakBar(context, 'Orders cleared successfuly');
                        } catch (error) {
                          showDialog(
                            context: context,
                            builder: (error) {
                              return ErrorDialog(error: error.toString());
                            },
                          );
                        }
                        setState(() {
                          inProgress = false;
                        });
                      },
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
      ),
    );
  }
}
