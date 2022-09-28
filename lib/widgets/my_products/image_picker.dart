import 'package:flutter/material.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/utils/input_validation.dart';
import 'package:shopy/widgets/input_field.dart';

class ImagePicker extends StatefulWidget {
  final void Function(String?)? onSaved;
  final String? initialUrl;
  const ImagePicker({
    required this.onSaved,
    this.initialUrl = '',
    Key? key,
  }) : super(key: key);

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  final TextEditingController _imageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _updateImage() {
    if (!_focusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _focusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _imageController.dispose();
    _focusNode.removeListener(_updateImage);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialUrl != null) {
      _imageController.text = widget.initialUrl!;
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: Container(
            height: deviceWidth(context) / 3,
            width: deviceWidth(context) / 3,
            decoration: BoxDecoration(
              border: Border.all(color: kGrey02),
            ),
            child: _imageController.text == ''
                ? const Center(child: Text('Enter a Url'))
                : Image.network(_imageController.text),
          ),
        ),
        Expanded(
          child: InputField(
              title: 'Image Url',
              controller: _imageController,
              focusNode: _focusNode,
              inputType: TextInputType.url,
              action: TextInputAction.done,
              onSaved: widget.onSaved,
              onEditingComplete: (val) {
                setState(() {
                  _imageController.text = val;
                });
              },
              validator: (val) {
                return urlValidator(val);
              }),
        ),
      ],
    );
  }
}
