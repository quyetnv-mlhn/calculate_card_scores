import 'dart:convert';

import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/controllers/app_controller.dart';
import 'package:calculate_score/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../models/player_entity.dart';
import '../models/round_enitty.dart';

class PlayDetailController extends GetxController {
  final appController = Get.find<AppController>();
  final dbHelper = DatabaseHelper();
  late Database db;
  RxBool isLoading = true.obs;

  RxString winner = ''.obs;
  int numericalOrder = 1;
  TextEditingController noteController = TextEditingController();

  RxList<RoundEntity> listRounds = <RoundEntity>[].obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    for (int i = 0; i < appController.quantity.value; ++i) {
      appController.players[i].score = List.generate(appController.quantity.value, (index) => 0);
    }

    db = await dbHelper.database();
    var arguments = Get.arguments;
    print(arguments);
    if (arguments != null &&
        arguments is Map &&
        arguments.containsKey('players') &&
        arguments.containsKey('lastScore')) {
      appController.resetData();
      await readFromDatabase();
    }
    isLoading.value = false;
  }

  Future<void> readFromDatabase() async {
    print("gameId: ${appController.gameId.value}");
    List<Map<String, Object?>> records =
        await db.rawQuery('SELECT * FROM $roundsTable WHERE gameId = ?', [appController.gameId.value]);
    print(records);
    int length = records.length;
    for (int i = 0; i < length; ++i) {
      RoundEntity round = RoundEntity.fromJson((records[i]));
      listRounds.add(round);
    }

    if (listRounds.isNotEmpty) {
      print("Get.arguments['players']: ${Get.arguments['players']}");
      int length = listRounds.length;
      int numberOfPlayers = listRounds[0].data!.length;
      appController.quantity.value = numberOfPlayers;
      numericalOrder = length + 1;
      List<String> listPlayerName = Get.arguments['players'];
      List<List<int>> lastScore = Get.arguments['lastScore'];
      for (int i = 0; i < numberOfPlayers; ++i) {
        appController.players[i].name = listPlayerName[i];
        appController.players[i].score = List.from(lastScore[i]);
      }
    }
  }

  Future<void> onSavePressed(context) async {
    final timestamp = DateTime.now().toIso8601String();
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

    final score = RoundEntity(
      gameId: appController.gameId.value,
      numericalOrder: numericalOrder.toString(),
      timeNow: DateFormat('HH:mm').format(DateTime.now()),
      data: scoreData,
      note: noteController.text,
    );

    String lastScore = jsonEncode(List.from(appController.players.where((element) => element.score != null).toList())
        .map((e) => e.score)
        .toList());

    listRounds.add(score);
    await dbHelper.addRound(appController.gameId.value, score.toJson());
    await dbHelper.updateGame(appController.gameId.value, "--", lastScore);

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
