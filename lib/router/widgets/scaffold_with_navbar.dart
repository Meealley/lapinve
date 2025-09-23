import 'package:flutter/material.dart';
import 'package:lapinve/router/widgets/bottom_navbar.dart';

class ScaffoldWithNavbar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavbar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, bottomNavigationBar: BottomNavBar());
  }
}
