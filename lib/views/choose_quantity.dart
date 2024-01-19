import 'package:calculate_score/components/button_custom.dart';
import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Obx(
          () => Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Số người chơi",
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
                spacing: 10,
                runSpacing: 10,
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
    );
  }

  Container buildEnterName(BuildContext context, int index, TextEditingController controller) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(right: 15),
      width: size.width / 2 - 25,
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
