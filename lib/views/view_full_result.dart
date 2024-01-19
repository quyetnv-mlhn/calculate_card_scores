import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/components/marqee_widget.dart';
import 'package:calculate_score/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/result_controller.dart';

class ViewFullResult extends StatelessWidget {
  ViewFullResult({super.key, required this.controller});

  ResultController controller;

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kết quả", style: TextStyle(color: Colors.white)),
        backgroundColor: blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         controller.initialData();
        //       },
        //       icon: Icon(Icons.refresh)),
        // ],
      ),
      body: Obx(() {
        controller.initialData();
        return SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Bấm vào tên để xem kết quả chi tiết",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: fontSizeMain),
                  textAlign: TextAlign.center,
                ),
              ),

              //build first row ["Chu no", name1, name2...]
              Row(
                children: [
                  CellTable(
                    height: width / (controller.quantity + 1),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MarqueeWidget(
                            child:
                                Text('Chủ nợ', style: TextStyle(fontSize: fontSizeMain, fontWeight: FontWeight.w800))),
                        Icon(Icons.arrow_downward_outlined, size: 18),
                      ],
                    ),
                  ),
                  for (int i = 0; i < controller.quantity; ++i)
                    CellTable(
                      height: width / (controller.quantity + 1),
                      text: appController.players[i].name,
                      onTap: () => buildViewResultDetail(context, appController, i),
                    )
                ],
              ),

              //build other rows [name, score1, score2...]
              for (int i = 0; i < controller.quantity; ++i)
                Row(
                  children: [
                    for (int j = 0; j < controller.quantity + 1; ++j)
                      j == 0
                          ? CellTable(
                              height: width / (controller.quantity + 1),
                              text: appController.players[i].name,
                              onTap: () => buildViewResultDetail(context, appController, i),
                            )
                          : CellTable(
                              height: width / (controller.quantity + 1),
                              text: '${controller.finalResult[i][j - 1].value}',
                            ),
                  ],
                )
            ],
          ),
        );
      }),
    );
  }

  Future<dynamic> buildViewResultDetail(BuildContext context, AppController appController, int index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MarqueeWidget(
                  child: Text(
                    appController.players[index].name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(width: double.infinity, child: buildPlayerAndDebtAmount(appController, index)),
                const SizedBox(height: 10),
                Text(
                  'Tổng: ${controller.summarizes[index]}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlayerAndDebtAmount(AppController appController, int index) {
    return Row(
      children: List.generate(
        controller.quantity,
        (i) => index == i
            ? const SizedBox.shrink()
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                child: Text('${controller.finalResult[index][i].value}',
                                    style: const TextStyle(fontSize: fontSizeMain, fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                      MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(
                          appController.players[i].name ?? 'noname',
                          style: const TextStyle(fontSize: fontSizeMain, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class CellTable extends StatelessWidget {
  CellTable({super.key, this.child, this.height, this.text, this.onTap});

  final Widget? child;
  final double? height;
  final String? text;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: MarqueeWidget(
              child: child ??
                  Text(text ?? '', style: const TextStyle(fontSize: fontSizeMain, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}
