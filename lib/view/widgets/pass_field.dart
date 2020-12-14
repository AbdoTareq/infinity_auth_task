import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TextField that takes TextEditingController from the main controller(ex:LoginController) to controll text from outside to be indebendent widget
class PassField extends StatelessWidget {
  const PassField({
    Key key,
    @required this.passwordTextController,
    this.focus,
    this.function,
    this.hint = '',
    this.validate,
    this.spaceAfter = true,
  }) : super(key: key);

  final TextEditingController passwordTextController;
  final FocusNode focus;
  final String hint;
  final bool spaceAfter;
  final Function function;
  final Function validate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: passwordTextController,
          decoration: InputDecoration(
            filled: true,
            labelText: hint.isEmpty ? 'pass'.tr : hint.tr,
          ),
          obscureText: true,
          focusNode: focus,
          validator: hint.isNotEmpty
              ? validate
              : (value) =>
                  GetUtils.isLengthLessThan(value, 5) ? 'pass_war'.tr : null,
          onFieldSubmitted: (_) async {
            try {
              await function();
            } catch (e) {}
          },
        ),
        if (spaceAfter)
          SizedBox(
            height: 20,
          ),
      ],
    );
  }
}
