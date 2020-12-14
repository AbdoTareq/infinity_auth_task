import 'package:flutter/material.dart';
import 'package:flutter_template/utils/langs/lang_keys.dart';
import 'package:get/get.dart';

// TextField that takes TextEditingController from the main controller(ex:LoginController) to controll text from outside to be indebendent widget
class UsernameField extends StatelessWidget {
  const UsernameField({
    Key key,
    this.focus,
    @required this.tEController,
    this.function,
    this.hint = '',
    this.spaceAfter = true,
    this.validateMessage = kMailWar,
    this.inputType,
    this.maxLength,
    this.registerFocus = false,
  }) : super(key: key);

  final FocusNode focus;
  final Function function;
  final String hint;
  final String validateMessage;
  final bool spaceAfter;
  final TextInputType inputType;
  final int maxLength;
  final bool registerFocus;

  final TextEditingController tEController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: tEController,
          decoration: InputDecoration(
            filled: true,
            labelText: hint.isEmpty ? kMail.tr : hint.tr,
          ),
          textInputAction: TextInputAction.next,
          autofocus: registerFocus,
          keyboardType: inputType,
          maxLength: maxLength,
          onFieldSubmitted: (v) async {
            FocusScope.of(context).requestFocus(focus);
            try {
              await function();
            } catch (e) {}
          },
          // validator: ((value) => !GetUtils.isEmail(value) ? kMailWar.tr : null),
          validator: ((value) => value.isEmpty? kMailWar.tr : null),
        ),
        if (spaceAfter)
          SizedBox(
            height: 20,
          ),
      ],
    );
  }
}
