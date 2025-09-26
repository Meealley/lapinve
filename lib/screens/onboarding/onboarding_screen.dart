// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:lapinve/screens/onboarding/onboarding_data.dart';
import 'package:lapinve/screens/onboarding/onboarding_page.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Welcome to Lapinve",
      description:
          // "Discover amazing features and services tailored just for you. Your journey begins here.",
          "Find the perfect ride for every journey — simple, fast, and reliable",
      icon: Icons.car_rental,
      color: Colors.blue,
    ),
    OnboardingData(
      title: "Easy to Use",
      description:
          // "Navigate through our intuitive interface with ease and comfort. Everything is designed for you.",
          "Book, unlock, and drive in just a few taps — no stress, no hassle.",
      icon: Icons.touch_app,
      color: Colors.green,
    ),
    OnboardingData(
      title: "Get Started",
      description:
          // "Join thousands of users who trust Lapinve for their daily needs. Ready to begin?",
          "Sign up today and hit the road with freedom at your fingertips",
      icon: Icons.rocket_launch,
      color: Colors.orange,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (_currentPage < _pages.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: TextButton(
                    onPressed: () => _navigateToLogin(),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox(height: 8.h),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  width: _currentPage == index ? 8.w : 2.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? _pages[index].color
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Next/Get Started button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SizedBox(
                width: double.infinity,
                height: 5.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _navigateToLogin();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _pages[_currentPage].color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.5.h),
                    ),
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
