import 'package:calculate_score/components/commons.dart';
import 'package:calculate_score/controllers/app_controller.dart';
import 'package:calculate_score/controllers/history_controller.dart';
import 'package:calculate_score/views/choose_quantity.dart';
import 'package:calculate_score/views/history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChooseQuantity(controller: Get.find<AppController>()),
        // pages[pageIndex],
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Colors.black87,
        //   selectedFontSize: 12,
        //   selectedIconTheme: const IconThemeData(color: Colors.white, size: 25),
        //   selectedItemColor: Colors.white,
        //   selectedLabelStyle: const TextStyle(fontFamily: 'Roboto'),
        //   unselectedLabelStyle: const TextStyle(fontFamily: 'Roboto'),
        //   unselectedIconTheme: const IconThemeData(color: Colors.white70, size: 22),
        //   unselectedItemColor: Colors.white70,
        //   unselectedFontSize: 11,
        //   showSelectedLabels: true,
        //   showUnselectedLabels: true,
        //   type: BottomNavigationBarType.fixed,
        //   items: [
        //     BottomNavigationBarItem(
        //         icon: Icon(pageIndex == 0 ? Icons.play_circle_outline_outlined : Icons.play_circle_fill_rounded),
        //         label: 'Tạo trò chơi'),
        //     BottomNavigationBarItem(
        //         icon: Icon(pageIndex == 1 ? Icons.history_outlined : Icons.manage_history), label: 'Lịch sử')
        //   ],
        //   currentIndex: pageIndex,
        //   onTap: (index) {
        //     if (index == 1) {
        //       Get.find<HistoryController>().readDatabase();
        //     }
        //     setState(() {
        //       pageIndex = index;
        //     });
        //   },
        // ),
      ),
    );
  }
}
