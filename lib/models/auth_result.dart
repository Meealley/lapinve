import 'package:equatable/equatable.dart';
import 'package:lapinve/models/user_model.dart';

enum AuthProvider { emailPassword, google, apple, facebook }

class SignUpData {
  final String fullName;
  final String email;
  final String? password;
  final AuthProvider provider;

  SignUpData({
    required this.fullName,
    required this.email,
    this.password,
    required this.provider,
  });
}

abstract class AuthResult extends Equatable {
  const AuthResult();

  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthResult {
  final UserModel user;
  final String? message;

  const AuthSuccess({required this.user, this.message});

  @override
  List<Object?> get props => [user, message];
}

class AuthFailure extends AuthResult {
  final String message;
  final String? code;

  const AuthFailure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}
