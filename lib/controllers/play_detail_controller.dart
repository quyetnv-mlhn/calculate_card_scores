import 'package:calculate_score/controllers/app_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/player_entity.dart';
import '../models/score_entity.dart';

class PlayDetailController extends GetxController {
  final appController = Get.find<AppController>();

  RxString winner = ''.obs;
  int numericalOrder = 1;
  TextEditingController noteController = TextEditingController();

  RxList<ScoreEntity> listScore = <ScoreEntity>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String hours = DateFormat('HH').format(DateTime.now());

    for (int i = 0; i < appController.quantity.value; ++i) {
      appController.players[i].score = List.generate(appController.quantity.value, (index) => 0);
    }
  }

  void onSavePressed(context) {
    final indexWinner = appController.players.indexOf(Player(name: winner.value, isWinner: true));
    final scoreData = <int>[];

    for (int i = 0; i < appController.quantity.value; ++i) {
      scoreData.add(appController.playersScore[i].text == '' ? 0 : int.parse(appController.playersScore[i].text));
      appController.players[indexWinner].score![i] += scoreData[i];
      if (i == indexWinner) continue;
      if (appController.playersScore[i].text == '' || appController.playersScore[i].text == '0') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Vui lòng điền đầy đủ thông tin!"),
          backgroundColor: Colors.redAccent.shade100,
          duration: const Duration(seconds: 1),
        ));
        return;
      }
    }

    listScore.add(ScoreEntity(
      numericalOrder: numericalOrder,
      timeNow: DateFormat('HH:mm').format(DateTime.now()),
      data: scoreData,
      note: noteController.text,
    ));

    for (int i = 0; i < appController.quantity.value; ++i) {
      print(appController.players[i].score);
    }

    numericalOrder++;
    Get.back();
  }

  void onSubtractPressed(int playerIndex) {
    int score;
    if (appController.playersScore[playerIndex].text != '') {
      score = int.parse(appController.playersScore[playerIndex].text);
      if (score == 0) return;
    } else {
      score = 1;
    }
    appController.playersScore[playerIndex].text = '${--score}';
  }

  void onAddPressed(int playerIndex) {
    int score;
    if (appController.playersScore[playerIndex].text != '') {
      score = int.parse(appController.playersScore[playerIndex].text);
    } else {
      score = 0;
    }
    appController.playersScore[playerIndex].text = '${++score}';
  }

  void onChangeOptionWinner(String? value, int playerIndex) {
    winner.value = value!;
    appController.players[playerIndex].isWinner = true;
    for (int i = 0; i < 5; ++i) {
      if (i == playerIndex) {
        appController.playersScore[i].text = '';
        continue;
      }
      appController.players[i].isWinner = false;
    }
  }
}
