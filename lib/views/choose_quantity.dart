import 'package:calculate_score/components/button_custom.dart';
import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/history_controller.dart';
import 'history_page.dart';

class ChooseQuantity extends StatelessWidget {
  ChooseQuantity({super.key, required this.controller});

  AppController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo trò chơi", style: TextStyle(color: Colors.white)),
        backgroundColor: blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () => Get.to(() => HistoryPage(controller: Get.put(HistoryController()))),
              icon: const Icon(Icons.history_outlined)),
        ],
      ),
      body: GestureDetector(
        onTapDown: (tapDownDetails) => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Obx(
            () => Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Nhập tên:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    DropdownButton<int>(
                      value: controller.quantity.value,
                      items: [
                        for (int i = 2; i <= 5; i++)
                          DropdownMenuItem<int>(
                            value: i,
                            child: Text("$i người chơi", style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                      ],
                      onChanged: (value) {
                        controller.quantity.value = value!;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 15,
                  children: List.generate(controller.quantity.value,
                      (index) => buildEnterName(context, index + 1, controller.nameController[index])),
                ),
                const Spacer(),
                Row(
                  children: [
                    CButton(
                      text: 'ĐIỀN NHANH',
                      iconData: Icons.add,
                      onPressed: () => controller.startGame(quickStart: true),
                    ),
                    const SizedBox(width: 10),
                    CButton(
                      text: 'BẮT ĐẦU',
                      iconData: Icons.not_started_outlined,
                      onPressed: () => controller.startGame(),
                      buttonColor: primaryColor,
                      textColor: blackColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEnterName(BuildContext context, int index, TextEditingController controller) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 2 - 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("$index", style: const TextStyle(fontSize: fontSizeMain)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(contentPadding: EdgeInsets.only(bottom: 5, top: 15), isDense: true),
              style: const TextStyle(fontSize: fontSizeMain),
            ),
          ),
        ],
      ),
    );
  }
}
