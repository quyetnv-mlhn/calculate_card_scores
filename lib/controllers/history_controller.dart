import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/controllers/play_detail_controller.dart';
import 'package:calculate_score/controllers/result_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../models/game_entity.dart';
import '../services/database_helper.dart';
import '../views/play_detail.dart';
import 'app_controller.dart';

class HistoryController extends GetxController {
  final dbHelper = DatabaseHelper();
  late Database db;
  RxList<GameEntity> histories = <GameEntity>[].obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    db = await dbHelper.database();
    await readDatabase();
  }

  Future<void> readDatabase() async {
    List<Map<String, Object?>> records = await db.rawQuery('SELECT * FROM $gamesTable WHERE lastScore IS NOT NULL');
    List<Map<String, Object?>> records2 = await db.rawQuery('SELECT * FROM $roundsTable WHERE gameId IS NOT NULL');

    for (var record in records) {
      print(record);
    }
    for (var record in records2) {
      print(record);
    }
    int length = records.length;
    if (length != histories.length) {
      for (int i = histories.length; i < length; ++i) {
        histories.insert(0, GameEntity.fromJson(records[i]));
      }
    }
  }

  Future<void> continueGame(int gameId, List<String> players, List<List<int>> lastScore) async {
    Get.find<AppController>().gameId.value = gameId;
    await Get.delete<PlayDetailController>();
    await Get.delete<ResultController>();
    await Get.to(() => PlayDetail(controller: Get.put(PlayDetailController())),
        arguments: {'players': players, 'lastScore': lastScore});
  }

  Future<bool> showConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận"),
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: blackColor, fontSize: fontSizeMain * 2),
          content: const Text("Bạn có chắc muốn xoá phần tử này?"),
          contentTextStyle: const TextStyle(fontWeight: FontWeight.w400, color: blackColor, fontSize: fontSizeMain),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Đồng ý",
                  style: TextStyle(fontWeight: FontWeight.w400, color: blackColor, fontSize: fontSizeMain)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Hủy",
                  style: TextStyle(fontWeight: FontWeight.w400, color: blackColor, fontSize: fontSizeMain)),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteGame(gameId) async {
    await dbHelper.deleteGame(gameId);
    histories.remove(histories.firstWhere((game) => game.gameId == gameId));
  }
}
