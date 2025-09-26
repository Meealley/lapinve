// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';

part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  loading,
  emailSignUpLoading,
  googleSignInLoading,
  appleSignInLoading,
  passwordResetLoading,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? error;
  final String? message;

  const AuthState({required this.status, this.user, this.error, this.message});

  factory AuthState.initial() {
    return AuthState(status: AuthStatus.unknown);
  }

  factory AuthState.loading() {
    return AuthState(status: AuthStatus.loading);
  }

  factory AuthState.authenticated(UserModel user, {String? message}) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      message: message,
    );
  }

  factory AuthState.unauthenticated({String? error}) {
    return AuthState(status: AuthStatus.unauthenticated, error: error);
  }

  factory AuthState.emailSignUpLoading() {
    return AuthState(status: AuthStatus.emailSignUpLoading);
  }

  factory AuthState.googleSignInLoading() {
    return AuthState(status: AuthStatus.googleSignInLoading);
  }

  factory AuthState.appleSignInLoading() {
    return AuthState(status: AuthStatus.appleSignInLoading);
  }

  factory AuthState.passwordResetLoading() {
    return AuthState(status: AuthStatus.passwordResetLoading);
  }

  // Convenience getters
  bool get isLoading => [
    AuthStatus.loading,
    AuthStatus.emailSignUpLoading,
    AuthStatus.googleSignInLoading,
    AuthStatus.appleSignInLoading,
    AuthStatus.passwordResetLoading,
  ].contains(status);

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get hasError => error != null && error!.isNotEmpty;

  @override
  List<Object?> get props => [status, user, error, message];

  @override
  bool get stringify => true;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}
