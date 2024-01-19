import 'dart:convert';

import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/controllers/play_detail_controller.dart';
import 'package:calculate_score/models/player_entity.dart';
import 'package:calculate_score/views/play_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../services/database_helper.dart';

class AppController extends GetxController {
  List<Player> players = List.generate(5, (index) => Player());
  List<TextEditingController> playersScore = List.generate(5, (index) => TextEditingController());
  List<TextEditingController> nameController = List.generate(5, (index) => TextEditingController());
  RxInt quantity = 2.obs;
  final dbHelper = DatabaseHelper();
  late Database db;
  RxInt gameId = 0.obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    for (var element in playersScore) {
      element.dispose();
    }
    for (var element in nameController) {
      element.dispose();
    }
  }

  void resetData() {
    for (int i = 0 ; i < 5; ++i) {
      players[i] = Player();
      playersScore[i].clear();
      nameController[i].clear();
    }
  }


  Future<void> startGame({bool quickStart = false}) async {
    if (!quickStart && !isPlayerValid) {
      Get.defaultDialog(title: 'Tên không hợp lệ', middleText: 'Bạn hãy nhập đầy đủ tên thành viên!');
      return;
    }

    if (quickStart) {
      for (int i = 0; i < quantity.value; ++i) {
        players[i].name = String.fromCharCode('A'.codeUnitAt(0) + i);
      }
    } else {
      for (int i = 0; i < quantity.value; ++i) {
        players[i].name = nameController[i].text;
      }
    }

    gameId.value = await dbHelper.addGame(players: jsonEncode(players.map((player) => player.name).toList()));
    Get.off(() => PlayDetail(controller: Get.put(PlayDetailController())));
  }

  get isPlayerValid {
    for (int i = 0; i < quantity.value; ++i) {
      if (nameController[i].text.isEmpty) {
        return false;
      }
    }
    return true;
  }
}
