// methods
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSimpleDialog({String title = '', String text = ''}) {
  Get.defaultDialog(
      title: title.isNotEmpty ? title : 'watch'.tr,
      middleText: text.isNotEmpty ? text : 'under_dev'.tr,
      titleStyle: TextStyle(color: Colors.red));
}
