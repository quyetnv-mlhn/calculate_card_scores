import 'package:calculate_score/components/button_custom.dart';
import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/components/marqee_widget.dart';
import 'package:calculate_score/controllers/app_controller.dart';
import 'package:calculate_score/controllers/result_controller.dart';
import 'package:calculate_score/models/score_entity.dart';
import 'package:calculate_score/views/view_full_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/play_detail_controller.dart';

class PlayDetail extends StatelessWidget {
  const PlayDetail({Key? key, required this.controller}) : super(key: key);

  final PlayDetailController controller;

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chi tiết trò chơi", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.list_alt_outlined),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewFullResult(controller: Get.put(ResultController()))));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showWinnerDialog(context, appController),
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: paddingMain),
          child: Obx(() {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildPlayerInfo(appController),
                  ...List.generate(
                    controller.listScore.length,
                    (index) => buildRowScore(
                      appController,
                      controller.listScore[controller.listScore.length - 1 - index],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Padding buildPlayerInfo(AppController appController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingMain),
      child: Row(
        children: List.generate(
          appController.quantity.value,
          (index) => buildPlayerNumber(appController.players[index].name ?? 'noname', index + 1),
        ),
      ),
    );
  }

  void _showWinnerDialog(context, appController) {
    controller.winner.value = '';
    appController.playersScore.forEach((playerScore) => playerScore.text = '');
    appController.players.forEach((player) => player.isWinner = null);
    controller.noteController.text = '';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        title: const Text(
          'Ai là người thắng nào :>',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        titlePadding: const EdgeInsets.symmetric(vertical: 15.0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    appController.quantity.value,
                    (index) => buildOptionWinner(appController, index),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: controller.noteController,
                      style: const TextStyle(fontSize: fontSizeMain),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        hintText: "Thêm bình luận của bạn tại đây",
                      ),
                    ),
                  )
                ],
              )),
        ),
        contentPadding: const EdgeInsets.only(left: 0, right: 15),
        actions: [buildAction(appController, context)],
        actionsPadding: const EdgeInsets.only(top: 25, right: 15, left: 15, bottom: 15),
      ),
    );
  }

  Widget buildAction(AppController appController, BuildContext context) => Row(
        children: [
          CButton(
            text: "ĐÓNG",
            iconData: Icons.close,
            onPressed: () {
              Get.back();
            },
          ),
          const SizedBox(width: 10),
          CButton(
            text: 'LƯU',
            iconData: Icons.save,
            buttonColor: CupertinoColors.systemYellow,
            textColor: Colors.black,
            onPressed: () => controller.onSavePressed(context),
          ),
        ],
      );

  Widget buildOptionWinner(AppController appController, int playerIndex) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildOptionName(appController, playerIndex),
            buildOptionScore(appController, playerIndex),
          ],
        ),
      ],
    );
  }

  Widget buildOptionScore(AppController appController, int playerIndex) {
    if (appController.players[playerIndex].isWinner == null) {
      return const Expanded(child: SizedBox.shrink());
    }
    return appController.players[playerIndex].isWinner ?? true
        ? Expanded(
            child: Center(
              child: SvgPicture.asset('assets/images/crown.svg', width: fontSizeMain * 2, height: fontSizeMain * 2),
            ),
          )
        : Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildCircleButton(Icons.remove, onTap: () => controller.onSubtractPressed(playerIndex)),
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: appController.playersScore[playerIndex],
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(contentPadding: EdgeInsets.all(0), hintText: '0'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                buildCircleButton(Icons.add, onTap: () => controller.onAddPressed(playerIndex)),
              ],
            ),
          );
  }

  Expanded buildOptionName(AppController appController, int playerIndex) {
    return Expanded(
      child: ListTile(
        title: MarqueeWidget(
          direction: Axis.horizontal,
          child: Text(
            appController.players[playerIndex].name ?? 'noname',
            style: TextStyle(
                fontSize: fontSizeMain,
                fontWeight: FontWeight.w600,
                color: appController.players[playerIndex].isWinner ?? false ? Colors.green : null),
          ),
        ),
        leading: Radio(
          activeColor: Colors.green,
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: appController.players[playerIndex].name ?? 'noname',
          groupValue: controller.winner.value,
          onChanged: (String? value) => controller.onChangeOptionWinner(value, playerIndex),
        ),
      ),
    );
  }

  Widget buildCircleButton(IconData iconData, {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: buttonRadius,
        height: buttonRadius,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }

  Expanded buildPlayerNumber(String name, int number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/images/hexagon.svg',
                    colorFilter: ColorFilter.mode(Colors.yellow.shade700, BlendMode.srcIn),
                  ),
                  Center(
                      child:
                          Text('$number', style: const TextStyle(fontSize: fontSizeMain, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            MarqueeWidget(
              direction: Axis.horizontal,
              child: Text(
                name,
                style: const TextStyle(fontSize: fontSizeMain, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRowScore(AppController appController, ScoreEntity scoreEntity) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.only(bottom: 5),
              color: Colors.grey,
              child: Text('${scoreEntity.numericalOrder}'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.only(bottom: 5),
              color: Colors.grey,
              child: Text('${scoreEntity.timeNow}'),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: paddingMain),
            ...List.generate(
              appController.quantity.value,
              (index) => Expanded(
                child: Center(
                  child: scoreEntity.data?[index] == 0
                      ? SvgPicture.asset('assets/images/crown.svg', width: fontSizeMain * 2, height: fontSizeMain * 2)
                      : Text(
                          '${scoreEntity.data?[index] ?? ''}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ),
            const SizedBox(width: paddingMain),
          ],
        ),
        if (scoreEntity.note != null && scoreEntity.note != '')
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${scoreEntity.note}'),
              const Icon(Icons.format_quote),
            ],
          ),
        const Divider(thickness: 1),
      ],
    );
  }
}
