import 'package:flutter/material.dart';

import 'package:shopy/utils/input_validation.dart';

import 'package:shopy/widgets/my_products/image_picker.dart';
import 'package:shopy/widgets/input_field.dart';
import 'package:shopy/widgets/my_products/save_button.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    dynamic product = ModalRoute.of(context)!.settings.arguments;
    Map formData = {};
    return Scaffold(
      appBar: AppBar(
        title: product != null
            ? const Text('Update product')
            : const Text('Add product'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              InputField(
                title: 'Title',
                action: TextInputAction.next,
                initialVal: product?.title,
                onSaved: (val) {
                  formData.putIfAbsent('title', () => val);
                },
                validator: titleValidator,
              ),
              InputField(
                title: 'Price',
                action: TextInputAction.next,
                inputType: TextInputType.number,
                initialVal: product?.price.toString(),
                onSaved: (val) {
                  formData.putIfAbsent('price', () => val);
                },
                validator: priceValidator,
              ),
              InputField(
                title: 'Description',
                action: TextInputAction.done,
                maxLines: 4,
                inputType: TextInputType.multiline,
                initialVal: product?.description,
                onSaved: (val) {
                  formData.putIfAbsent('desc', () => val);
                },
                validator: descriptionValidator,
              ),
              ImagePicker(
                initialUrl: product?.imageUrl,
                onSaved: (val) {
                  formData.putIfAbsent('url', () => val);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SaveButton(
        formKey: _key,
        formData: formData,
        productId: product?.id,
      ),
    );
  }
}
