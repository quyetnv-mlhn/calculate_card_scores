import 'package:calculate_score/controllers/app_controller.dart';
import 'package:calculate_score/views/choose_quantity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: ChooseQuantity(controller: Get.find<AppController>())));
  }
}
