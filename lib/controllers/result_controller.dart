import 'dart:convert';

import 'package:calculate_score/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../components/commons.dart';
import '../services/database_helper.dart';

class ResultController extends GetxController {
  final appController = Get.find<AppController>();
  final dbHelper = DatabaseHelper();
  late Database db;

  List<List<RxInt>> finalResult = [];
  List<RxInt> summarizes = [];

  int quantity = 0;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    db = await dbHelper.database();
    await initialData();
  }

  Future<void> initialData() async {
    quantity = appController.quantity.value;
    finalResult = List.generate(quantity, (index) => List.generate(quantity, (index2) => 0.obs));
    summarizes = List.generate(quantity, (index) => 0.obs);

    int indexMax = 0;

    for (int i = 0; i < quantity; ++i) {
      for (int j = 0; j < quantity; ++j) {
        if (j == i) continue;
        final different = appController.players[i].score![j] - appController.players[j].score![i];
        finalResult[i][j] = different.obs;
        summarizes[i] += different;
      }
      if (summarizes[i].value >= summarizes[indexMax].value) indexMax = i;
    }

    String lastScore = jsonEncode(List.from(appController.players.where((element) => element.score != null).toList())
        .map((e) => e.score)
        .toList());

    await dbHelper.updateGame(appController.gameId.value, appController.players[indexMax].name ?? "--", lastScore);
  }
}
