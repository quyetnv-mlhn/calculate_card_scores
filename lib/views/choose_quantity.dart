import 'dart:convert';

import 'package:calculate_score/components/button_custom.dart';
import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/controllers/app_controller.dart';
import 'package:calculate_score/controllers/play_detail_controller.dart';
import 'package:calculate_score/views/play_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseQuantity extends StatelessWidget {
  ChooseQuantity({super.key, required this.controller});

  AppController controller;

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Obx(() => Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Số người chơi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DropdownButton<int>(
                    value: controller.quantity.value,
                    items: const [
                      DropdownMenuItem<int>(
                          value: 2, child: Text("2 người chơi", style: TextStyle(fontWeight: FontWeight.w600))),
                      DropdownMenuItem<int>(
                          value: 3, child: Text("3 người chơi", style: TextStyle(fontWeight: FontWeight.w600))),
                      DropdownMenuItem<int>(
                          value: 4, child: Text("4 người chơi", style: TextStyle(fontWeight: FontWeight.w600))),
                      DropdownMenuItem<int>(
                          value: 5, child: Text("5 người chơi", style: TextStyle(fontWeight: FontWeight.w600))),
                    ],
                    onChanged: (value) {
                      controller.quantity.value = value!;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                    controller.quantity.value, (index) => buildEnterName(context, controller.nameController[index])),
              ),
              const Spacer(),
              Row(
                children: [
                  CButton(
                    text: 'ĐIỀN NHANH',
                    iconData: Icons.add,
                    onPressed: () {
                      for (int i = 0; i < controller.quantity.value; ++i) {
                        appController.players[i].name = String.fromCharCode('A'.codeUnitAt(0) + i);
                      }
                      Get.off(PlayDetail(controller: Get.put(PlayDetailController())));
                    },
                  ),
                  const SizedBox(width: 10),
                  CButton(
                    text: 'BẮT ĐẦU',
                    iconData: Icons.not_started_outlined,
                    onPressed: () {
                      if (!isPlayerValid) {
                        Get.defaultDialog(title: 'Tên không hợp lệ', middleText: 'Bạn hãy nhập đầy đủ tên thành viên!');
                        return;
                      }
                      for (int i = 0; i < controller.quantity.value; ++i) {
                        appController.players[i].name = controller.nameController[i].text;
                      }
                      Get.off(PlayDetail(controller: Get.put(PlayDetailController())));
                    },
                    buttonColor: CupertinoColors.systemYellow,
                    textColor: Colors.black,
                  ),
                ],
              )
            ],
          )),
    );
  }

  SizedBox buildEnterName(BuildContext context, TextEditingController controller) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 2 - 25,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  get isPlayerValid {
    for (int i = 0; i < controller.quantity.value; ++i) {
      if (controller.nameController[i].text.isEmpty) {
        return false;
      }
    }
    return true;
  }
}
