import 'package:calculate_score/controllers/app_controller.dart';
import 'package:get/get.dart';

class ResultController extends GetxController {
  final appController = Get.find<AppController>();

  List<List<RxInt>> finalResult = [];

  int quantity = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialData();
  }

  void initialData() {
    quantity = appController.quantity.value;
    finalResult = List.generate(quantity, (index) => List.generate(quantity, (index2) => 0.obs));

    for (int i = 0; i < quantity; ++i) {
      for (int j = 0; j < quantity; ++j) {
        // if (j == i) continue;
        finalResult[i][j] = RxInt(appController.players[i].score![j] - appController.players[j].score![i]);
      }
    }

    // for (int i = 0; i < quantity; ++i) {
    //   print(finalResult[i]);
    // }
  }
}
