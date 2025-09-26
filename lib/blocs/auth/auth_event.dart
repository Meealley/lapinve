part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Authentication State Monitoring
class AuthStatusRequested extends AuthEvent {
  const AuthStatusRequested();
}

// Internal Request for User Stream Changes
class AuthUserChanged extends AuthEvent {
  final UserModel? user;
  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

// Email & Password Authentication
class SignUpWithEmailRequested extends AuthEvent {
  final SignUpData signUpData;

  const SignUpWithEmailRequested({required this.signUpData});

  @override
  List<Object?> get props => [signUpData];
}

class SignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Social Authentication Events
class SignInWithGoogleRequested extends AuthEvent {
  const SignInWithGoogleRequested();
}

class SignInWithAppleRequested extends AuthEvent {
  const SignInWithAppleRequested();
}

// Password Reset
class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// Sign Out
class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

// Profile Updates
class UpdateDisplayNameRequested extends AuthEvent {
  final String displayName;

  const UpdateDisplayNameRequested({required this.displayName});

  @override
  List<Object?> get props => [displayName];
}

class UpdateEmailRequested extends AuthEvent {
  final String newEmail;

  const UpdateEmailRequested({required this.newEmail});

  @override
  List<Object?> get props => [newEmail];
}

// Account Deletion
class DeleteAccountRequested extends AuthEvent {
  const DeleteAccountRequested();
}
