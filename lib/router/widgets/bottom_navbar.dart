import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lapinve/router/widgets/nav_bar_item.dart';

// Custom Bottom Navigation Bar
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/search',
    '/favorite',
    '/trips',
    '/inbox',
    '/more',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_routes[index]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update selected index based on current route
    final String currentRoute = GoRouter.of(
      context,
    ).routeInformationProvider.value.location;
    final int index = _routes.indexOf(currentRoute);
    if (index != -1 && index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                icon: FontAwesomeIcons.magnifyingGlass,
                label: 'Search',
                isSelected: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              NavBarItem(
                icon: FontAwesomeIcons.accusoft,
                label: 'Favorite',
                isSelected: _selectedIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              NavBarItem(
                icon: FontAwesomeIcons.route,
                label: 'Trips',
                isSelected: _selectedIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
              NavBarItem(
                icon: FontAwesomeIcons.commentDots,
                label: 'Inbox',
                isSelected: _selectedIndex == 3,
                onTap: () => _onItemTapped(3),
              ),
              NavBarItem(
                icon: FontAwesomeIcons.ellipsis,
                label: 'More',
                isSelected: _selectedIndex == 4,
                onTap: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
