import 'package:flutter/material.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/error_dialog.dart';
import 'package:shopy/widgets/snackbar.dart';

class CartDialog extends StatefulWidget {
  final Map productData;
  final Future<void> Function(String, String, double, int) addCallBack;
  final Future<void> Function(String)? undoCallBack;
  final BuildContext ctx;
  final String action;
  const CartDialog({
    required this.productData,
    required this.addCallBack,
    this.undoCallBack,
    required this.ctx,
    required this.action,
    Key? key,
  }) : super(key: key);

  @override
  State<CartDialog> createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  int itemCount = 1;
  bool isLoading = false;

  @override
  void initState() {
    itemCount = widget.action == 'Edit' ? widget.productData['quantity'] : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: deviceHeight(context) * 0.3,
          maxHeight: deviceHeight(context) * 0.4,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.productData['title'],
              style: kTitleStyle.copyWith(color: kRusticRed),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  color: kRusticRed,
                  onPressed: () {
                    setState(() {
                      itemCount += 1;
                    });
                  },
                ),
                Text(
                  '$itemCount',
                  style: kGeneralTxtStyle.copyWith(
                    color: kRusticRed,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  color: kRusticRed,
                  onPressed: () {
                    setState(() {
                      if (itemCount > 1) {
                        itemCount -= 1;
                      }
                    });
                  },
                ),
              ],
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
                  child: isLoading == false
                      ? Text(widget.action)
                      : const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: kRusticRed),
                        ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      await widget.addCallBack(
                        widget.productData['id'],
                        widget.productData['title'],
                        widget.productData['price'],
                        itemCount,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: widget.action == 'Edit'
                              ? const Text('Item has been edited successfully')
                              : const Text('Item added successfully'),
                          action: widget.action == 'Edit'
                              ? null
                              : SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () async {
                                    try {
                                      await widget.undoCallBack!(
                                          widget.productData['id']);
                                      customSnakBar(
                                        widget.ctx,
                                        'Item deleted successfully',
                                      );
                                    } catch (error) {
                                      customSnakBar(
                                        widget.ctx,
                                        'Could not delete item',
                                      );
                                    }
                                  },
                                ),
                        ),
                      );
                    } catch (error) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorDialog(error: error.toString());
                        },
                      );
                    }
                    setState(() {
                      isLoading = false;
                    });
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
                  child: const Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
