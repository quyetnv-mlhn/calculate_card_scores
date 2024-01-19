import 'package:calculate_score/components/commons.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../models/game_entity.dart';
import '../services/database_helper.dart';

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
    int length = records.length;
    for (int i = 0; i < length; ++i) {
      histories.insert(0, GameEntity.fromJson(records[i]));
    }
  }
}
