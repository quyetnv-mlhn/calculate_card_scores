import 'package:calculate_score/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../components/commons.dart';
import '../components/marqee_widget.dart';

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
      body: WillPopScope(
        onWillPop: () async {
          Get.delete<HistoryController>();
          return true;
        },
        child: Obx(() {
          controller.histories.length;

          return GroupedListView(
            elements: controller.histories,
            groupBy: (element) => DateFormat('dd/MM').format(DateTime.parse(element.timestamp ?? '')),
            groupComparator: (value1, value2) => value1.compareTo(value2),
            itemComparator: (item1, item2) => item1.timestamp!.compareTo(item2.timestamp ?? ''),
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: true,
            groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            itemBuilder: (c, element) => buildHistoryItem(
              context,
              element.gameId ?? 0,
              DateFormat('HH:mm').format(DateTime.parse(element.timestamp ?? '')),
              element.players ?? [],
              element.winner ?? '--',
              element.lastScore ?? [[]],
            ),
          );
        }),
      ),
    );
  }

  Widget buildHistoryItem(
      context, int gameId, String time, List<String> players, String winner, List<List<int>> lastScore) {
    return Dismissible(
      key: Key(gameId.toString()),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.startToEnd: 0.8},
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      confirmDismiss: (direction) async => await controller.showConfirmationDialog(context),
      onDismissed: (direction) async => await controller.deleteGame(gameId),
      child: Card(
        elevation: 4,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        child: InkWell(
          onTap: () async => await controller.continueGame(gameId, players, lastScore),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            leading: Column(
              children: [
                const Icon(Icons.bubble_chart_outlined),
                Text(time, style: const TextStyle(fontSize: fontSizeMain, fontWeight: FontWeight.bold)),
              ],
            ),
            title: buildPlayerInfo(players, winner),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }

  Widget buildPlayerInfo(List<String> players, String winner) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: fontSizeMain, fontFamily: 'Mulish'),
            children: [
              const TextSpan(text: "Người chiến thắng: ", style: TextStyle(color: blackColor)),
              TextSpan(text: winner, style: const TextStyle(fontWeight: FontWeight.bold, color: blackColor)),
            ],
          ),
        ),
        SizedBox(height: 5),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: fontSizeMain, fontFamily: 'Mulish'),
            children: [
              const TextSpan(text: "Danh sách người chơi: ", style: TextStyle(color: blackColor)),
              TextSpan(
                  text: players.join(', '), style: const TextStyle(fontWeight: FontWeight.bold, color: blackColor)),
            ],
          ),
        ),
      ],
    );
  }
}
