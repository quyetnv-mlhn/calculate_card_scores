import 'package:calculate_score/controllers/app_controller.dart';
import 'package:calculate_score/controllers/history_controller.dart';
import 'package:calculate_score/controllers/play_detail_controller.dart';
import 'package:calculate_score/controllers/result_controller.dart';
import 'package:calculate_score/views/play_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/commons.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key, required this.controller}) : super(key: key);

  final HistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử tính điểm", style: TextStyle(color: Colors.white)),
        backgroundColor: blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.histories.length,
            itemBuilder: (context, index) {
              var game = controller.histories[index];
              return buildHistoryItem(game.gameId ?? 0, game.timestamp ?? '--', game.players ?? [], game.winner ?? '--',
                  game.lastScore ?? [[]]);
            },
          )),
    );
  }

  Widget buildHistoryItem(int gameId, String time, List<String> players, String winner, List<List<int>> lastScore) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () async {
          Get.find<AppController>().gameId.value = gameId;
          await Get.delete<PlayDetailController>();
          await Get.delete<ResultController>();
          Get.to(PlayDetail(controller: Get.put(PlayDetailController())),
              arguments: {'players': players, 'lastScore': lastScore});
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: const TextStyle(fontSize: fontSizeMain, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: fontSizeMain, fontFamily: 'Mulish'),
                  children: [
                    const TextSpan(text: "Người chiến thắng: ", style: TextStyle(color: blackColor)),
                    TextSpan(text: winner, style: const TextStyle(fontWeight: FontWeight.bold, color: blackColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
