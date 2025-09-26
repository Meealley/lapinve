// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapinve/blocs/auth/auth_bloc.dart';
import 'package:lapinve/screens/home_screen.dart';
import 'package:lapinve/utils/alert_utils.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  // final bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.trim().isEmpty) {
      AlertUtils.showErrorAlert(
        context: context,
        title: "Email required",
        message: "Please Enter an Email first",
      );
      return;
    }
    context.read<AuthBloc>().add(
      PasswordResetRequested(email: _emailController.text.trim()),
    );
  }

  // void _handleLogin() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     // Simulate login process
  //     await Future.delayed(const Duration(seconds: 2));

  //     setState(() {
  //       _isLoading = false;
  //     });

  //     // Simple validation - any email and password 6+ chars
  //     if (_emailController.text.isNotEmpty &&
  //         _passwordController.text.length >= 6) {
  //       context.go('/search');
  //     } else {
  //       AlertUtils.showErrorAlert(
  //         context: context,
  //         title: 'Login Failed',
  //         message:
  //             'Invalid credentials. Please enter a valid email and password with at least 6 characters.',
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/search');
        }

        // Handle errors
        if (state.hasError) {
          AlertUtils.showErrorAlert(
            context: context,
            title: 'Login Failed',
            message: state.error!,
          );
        }

        // Handle password reset success
        if (state.status == AuthStatus.unauthenticated &&
            state.message != null) {
          // This handles password reset success message
          AlertUtils.showPlatformAlert(
            context: context,
            title: 'Password Reset',
            message: state.message!,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;
          final isPasswordResetting =
              state.status == AuthStatus.passwordResetLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),

                      // Logo/Brand section
                      Center(
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset(
                                "assets/images/lapinve_logo.png",
                                height: 15.h,
                                width: 30.w,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Sign in to continue to Lapinve',
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Email field
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 3.h),

                      // Password field
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: Colors.grey[600],
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      // SizedBox(height: 1.5.h),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isPasswordResetting
                              ? null
                              : _handleForgotPassword,
                          child: Text(
                            isPasswordResetting
                                ? 'Sending...'
                                : 'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 5.h,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.5.h),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 3.h,
                                  width: 3.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 2.5.h),

                      // Sign up link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go("/signup");
                                // AlertUtils.showPlatformAlert(
                                //   context: context,
                                //   title: 'Sign Up',
                                //   message:
                                //       'Account registration feature is coming soon! Stay tuned for updates.',
                                // );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
