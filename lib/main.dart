import 'package:flutter/material.dart';
import 'package:lapinve/router/app_router.dart';
import 'package:lapinve/screens/home_screen.dart';

void main() {
  runApp(LapInve());
}

class LapInve extends StatelessWidget {
  const LapInve({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "DMSans"),
      routerConfig: router,
    );
  }
}
