import 'package:flutter/material.dart';
import 'package:lapinve/router/app_router.dart';
import 'package:lapinve/screens/home_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await RiveFile.initialize();
  runApp(LapInve());
}

class LapInve extends StatelessWidget {
  const LapInve({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "DMSans"),
          routerConfig: router,
        );
      },
    );
  }
}
