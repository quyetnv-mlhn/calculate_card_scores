import 'package:calculate_score/app_view.dart';
import 'package:calculate_score/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Mulish',
      ),
      home: const MyAppView(),
      initialBinding: BindingsBuilder.put(() => AppController(), permanent: true),
    );
  }
}
