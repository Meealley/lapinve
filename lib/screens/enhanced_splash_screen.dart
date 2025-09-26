// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _loadingOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
    _navigateToOnboarding();
  }

  void _initAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Loading animation
    _loadingOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeOut),
    );
  }

  void _startAnimationSequence() async {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Start loading animation
    await Future.delayed(const Duration(milliseconds: 400));
    _loadingController.forward();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFF), Color(0xFFE8F2FF), Color(0xFFD6E7FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated Logo
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Container(
                        width: 35.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.w),
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Image.asset(
                              'assets/images/lapinve_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 6.h),

              // Animated App Name
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _textSlideAnimation.value),
                    child: Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            'Lapinve',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1565C0),
                              fontFamily: 'DMSans',
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Your journey starts here',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF64748B),
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 3),

              // Animated Loading Indicator
              // AnimatedBuilder(
              //   animation: _loadingController,
              //   builder: (context, child) {
              //     return Opacity(
              //       opacity: _loadingOpacityAnimation.value,
              //       child: Column(
              //         children: [
              //           SizedBox(
              //             width: 8.w,
              //             height: 8.w,
              //             child: CircularProgressIndicator(
              //               strokeWidth: 0.8.w,
              //               valueColor: const AlwaysStoppedAnimation<Color>(
              //                 Color(0xFF1565C0),
              //               ),
              //             ),
              //           ),
              //           SizedBox(height: 3.h),
              //           Text(
              //             'Loading...',
              //             style: TextStyle(
              //               fontSize: 12.sp,
              //               color: const Color(0xFF64748B),
              //               fontFamily: 'DMSans',
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
