import 'package:flutter/material.dart';
import 'package:get/get.dart';

// submit btn in the auth form
class SubmitBtn extends StatelessWidget {
  const SubmitBtn({
    Key key,
    @required this.text,
    this.fontSize = 20,
    this.color,
    @required this.function,
    this.txtColor,
  }) : super(key: key);

  final Function function;
  final String text;
  final double fontSize;
  final Color color;
  final Color txtColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            child: Text(
              text.tr,
              style: TextStyle(fontSize: fontSize),
            ),
            onPressed: function,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            color: color.isNull ? Theme.of(context).primaryColor : color,
            textColor: txtColor.isNull ? Theme.of(context).primaryTextTheme.button.color : txtColor,
          ),
        ),
      ],
    );
  }
}
