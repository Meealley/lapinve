// lib/screens/signup_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lapinve/blocs/auth/auth_bloc.dart';
import 'package:lapinve/models/auth_result.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:lapinve/utils/alert_utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  // final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    // _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Functions for handling email signup
  void _handleEmailSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      AlertUtils.showErrorAlert(
        context: context,
        message:
            "Please accept the Terms of Service and Privacy Policy to continue.",
        title: "Terms Required",
      );
      return;
    }

    final signUpData = SignUpData(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text, // Include password
      provider: AuthProvider.emailPassword,
    );

    // if (_formKey.currentState!.validate()) {
    //   final signupData = SignUpData(
    //     fullName: _fullNameController.text.trim(),
    //     email: _emailController.text.trim(),
    //     provider: AuthProvider.emailPassword,
    //   );

    // }
    context.read<AuthBloc>().add(
      SignUpWithEmailRequested(signUpData: signUpData),
    );
  }

  // Functions for handling Google signup
  void _handleGoogleSignup() async {
    context.read<AuthBloc>().add(const SignInWithGoogleRequested());
  }

  void _handleAppleSignup() {
    // Implement Apple Sign-In logic here
    context.read<AuthBloc>().add(const SignInWithAppleRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated && state.message != null) {
          context.go('/search');
        }
        // Handle errors
        if (state.hasError) {
          AlertUtils.showErrorAlert(
            context: context,
            title: 'Signup Failed',
            message: state.error!,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isEmailLoading = state.status == AuthStatus.emailSignUpLoading;
          final isGoogleLoading =
              state.status == AuthStatus.googleSignInLoading;
          final isAppleLoading = state.status == AuthStatus.appleSignInLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600]),
                onPressed: () => context.go('/login'),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 4.h),

                      // Header section
                      Center(
                        child: Column(
                          children: [
                            // Image.asset(
                            //   "assets/images/lapinve_logo.png",
                            //   height: 15.h,
                            //   width: 30.w,
                            // ),
                            // SizedBox(height: 2.h),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Sign up to start your car rental journey',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Full Name field
                      _buildInputField(
                        label: 'Full Name',
                        controller: _fullNameController,
                        hint: 'Enter your full name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.trim().split(' ').length < 2) {
                            return 'Please enter your first and last name';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Email field
                      _buildInputField(
                        label: 'Email Address',
                        controller: _emailController,
                        hint: 'Enter your email address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Phone field
                      // _buildInputField(
                      //   label: 'Phone Number',
                      //   controller: _phoneController,
                      //   hint: 'Enter your phone number',
                      //   icon: Icons.phone_outlined,
                      //   keyboardType: TextInputType.phone,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter your phone number';
                      //     }
                      //     if (value.length < 10) {
                      //       return 'Please enter a valid phone number';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      SizedBox(height: 2.h),

                      // Password field
                      _buildPasswordField(
                        label: 'Password',
                        controller: _passwordController,
                        hint: 'Create a strong password',
                        isVisible: _isPasswordVisible,
                        onToggle: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                          ).hasMatch(value)) {
                            return 'Password must contain uppercase, lowercase and number';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Confirm Password field
                      _buildPasswordField(
                        label: 'Confirm Password',
                        controller: _confirmPasswordController,
                        hint: 'Confirm your password',
                        isVisible: _isConfirmPasswordVisible,
                        onToggle: () => setState(
                          () => _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 3.h),

                      // Terms and conditions checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) =>
                                setState(() => _acceptTerms = value!),
                            activeColor: Colors.blue,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _acceptTerms = !_acceptTerms),
                              child: Text.rich(
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      //  Email Sign up button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleEmailSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.h),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 3.h,
                                  width: 3.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Social signup buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 5.h,
                            child: ElevatedButton(
                              onPressed: isGoogleLoading
                                  ? null
                                  : _handleGoogleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                elevation: 0,
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.5.h),
                                ),
                              ),
                              child: isGoogleLoading
                                  ? SizedBox(
                                      height: 3.h,
                                      width: 3.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.blue,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.google,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          'Continue with Google',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          SizedBox(height: 2.h),

                          // Apple SignUp (IOS only)
                          if (Platform.isIOS)
                            SizedBox(
                              width: double.infinity,
                              height: 5.h,
                              child: ElevatedButton(
                                onPressed: isAppleLoading
                                    ? null
                                    : _handleAppleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.5.h),
                                  ),
                                ),
                                child: isAppleLoading
                                    ? SizedBox(
                                        height: 3.h,
                                        width: 3.h,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.apple,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 3.w),
                                          Text(
                                            'Continue with Apple',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                        ],
                      ),

                      // Login link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                              ),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(icon, color: Colors.grey[600]),
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
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey[600]),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: onToggle,
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
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
          ),
        ),
      ],
    );
  }

  // void _handleSignup() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   if (!_acceptTerms) {
  //     AlertUtils.showErrorAlert(
  //       context: context,
  //       title: 'Terms Required',
  //       message:
  //           'Please accept the Terms of Service and Privacy Policy to continue.',
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 2));

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   // Simulate successful signup
  //   await AlertUtils.showSuccessAlert(
  //     context: context,
  //     title: 'Account Created!',
  //     message:
  //         'Welcome to Lapinve! Your account has been created successfully.',
  //   );

  //   // Navigate to main app
  //   if (mounted) {
  //     context.go('/search');
  //   }
  // }
}
