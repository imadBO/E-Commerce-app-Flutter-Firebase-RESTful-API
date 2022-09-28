import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/products_provider.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/error_dialog.dart';
import 'package:shopy/widgets/snackbar.dart';

class SaveButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map formData;
  final String? productId;
  const SaveButton({
    required this.formKey,
    required this.formData,
    this.productId,
    Key? key,
  }) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      child: TextButton(
        child: widget.productId != null
            ? isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Text('Update product')
            : isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Text('Add product'),
        style: TextButton.styleFrom(
          backgroundColor: kRusticRed,
          primary: kWhite,
          textStyle: kGeneralTxtStyle.copyWith(fontSize: 18),
          fixedSize: Size(deviceWidth(context) - 30, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () async {
          if (widget.formKey.currentState!.validate()) {
            var provider =
                Provider.of<ProductsProvider>(context, listen: false);
            widget.formKey.currentState!.save();
            setState(() {
              isLoading = true;
            });
            if (widget.productId == null) {
              try {
                await provider.addProduct(widget.formData);
                customSnakBar(context, 'The product is added successfully');
              } catch (error) {
                await showDialog<void>(
                    context: context,
                    builder: (ctx) {
                      return const ErrorDialog();
                    });
              }
            } else {
              try {
                await provider.updateProduct(
                    widget.productId!, widget.formData);
                customSnakBar(context, 'The product is updated successfully');
              } catch (_) {
                await showDialog<void>(
                    context: context,
                    builder: (ctx) {
                      return const ErrorDialog();
                    });
              }
            }
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
