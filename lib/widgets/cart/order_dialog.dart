import 'package:flutter/material.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/error_dialog.dart';
import 'package:shopy/widgets/input_field.dart';
import 'package:shopy/widgets/snackbar.dart';

class OrderDialog extends StatefulWidget {
  final Future<void> Function(double, dynamic, String) orderCallBack;
  final Future<void> Function() clearCartCallBack;
  final double amount;
  final dynamic products;
  const OrderDialog({
    required this.orderCallBack,
    required this.clearCartCallBack,
    required this.amount,
    required this.products,
    Key? key,
  }) : super(key: key);
  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  bool isLoading = false;
  String shippingAddress = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: deviceHeight(context) * 0.2,
          maxHeight: deviceHeight(context) * 0.4,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Form(
                key: _formKey,
                child: InputField(
                  title: 'Shipping address',
                  onSaved: (address) {
                    shippingAddress = address!;
                  },
                  validator: (address) {
                    return address!.isEmpty
                        ? 'Please provide an address where you want your orders to be shiped to.'
                        : null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kRusticRed,
                      onPrimary: kWhite,
                      padding: const EdgeInsets.all(4),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: kRusticRed),
                          )
                        : const Text('Order'),
                    onPressed: () async {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await widget.orderCallBack(
                            widget.amount,
                            widget.products,
                            shippingAddress,
                          );
                          await widget.clearCartCallBack();
                          Navigator.of(context).pop();
                          customSnakBar(context, 'Orders passed successfully');
                        } catch (error) {
                          Navigator.pop(context);
                          await showDialog(
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
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kGreyishPink,
                      onPrimary: kWhite,
                      padding: const EdgeInsets.all(4),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
