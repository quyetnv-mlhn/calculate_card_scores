import 'package:calculate_score/models/player_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  List<Player> players = List.generate(5, (index) => Player());
  List<TextEditingController> playersScore = List.generate(5, (index) => TextEditingController());
  List<TextEditingController> nameController = List.generate(5, (index) => TextEditingController());
  RxInt quantity = 2.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    playersScore.forEach((element) {
      element.dispose();
    });
    nameController.forEach((element) {
      element.dispose();
    });
  }
}
