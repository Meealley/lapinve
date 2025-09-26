import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lapinve/blocs/auth/auth_bloc.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Redirect to login if user is unautthenticated
        if (state.status == AuthStatus.unauthenticated) {
          context.go("/login");
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Show loading while checking auth status
          if (state.status == AuthStatus.unknown ||
              state.status == AuthStatus.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          // If authenticated, show the requested page
          if (state.isAuthenticated) {
            return child;
          }

          // If not authenticated, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        },
      ),
    );
  }
}
