import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapinve/models/auth_result.dart';
import 'package:lapinve/models/user_model.dart';
import 'package:lapinve/repositories/auth_repository_interface.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryInterface _authRepository;
  StreamSubscription<UserModel?>? _userStreamSubscription;

  AuthBloc({required AuthRepositoryInterface authRepository})
    : _authRepository = authRepository,
      super(AuthState.initial()) {
    // Listen to user state from firestore
    _userStreamSubscription = _authRepository.userStream.listen((user) {
      if (user != null) {
        add(AuthUserChanged(user));
      } else {
        add(const AuthUserChanged(null));
      }
    });

    // Register event handlers
    on<AuthStatusRequested>(_onAuthStatusRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<SignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    on<SignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<SignInWithGoogleRequested>(_onSignInGoogleRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onAuthStatusRequested(
    AuthStatusRequested event,
    Emitter<AuthState> emit,
  ) {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    final user = event.user;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onSignUpWithEmailRequested(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.emailSignUpLoading());
    final result = await _authRepository.signUpWithEmailAndPassword(
      event.signUpData,
    );
    if (result is AuthSuccess) {
      emit(AuthState.authenticated(result.user, message: result.message));
    } else if (result is AuthFailure) {
      emit(AuthState.unauthenticated(error: result.message));
    }
  }

  Future<void> _onSignInWithEmailRequested(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    final result = await _authRepository.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    if (result is AuthSuccess) {
      emit(AuthState.authenticated(result.user, message: result.message));
    } else if (result is AuthFailure) {
      emit(AuthState.unauthenticated(error: result.message));
    }
  }

  Future<void> _onSignInGoogleRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.googleSignInLoading());
    final result = await _authRepository.signInWithGoogle();

    if (result is AuthSuccess) {
      emit(AuthState.authenticated(result.user, message: result.message));
    } else if (result is AuthFailure) {
      // Check if the user cancelled the sign-in - Don't show error; return to previous state
      if (result.message.toLowerCase().contains('cancelled')) {
        final currentUser = _authRepository.currentUser;
        if (currentUser != null) {
          emit(AuthState.authenticated(currentUser));
        } else {
          emit(AuthState.unauthenticated());
        }
      } else {
        emit(AuthState.unauthenticated(error: result.message));
      }
    }
  }

  Future<void> _onSignInWithAppleRequested(
    SignInWithAppleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.appleSignInLoading());

    final result = await _authRepository.signInWithApple();

    if (result is AuthSuccess) {
      emit(AuthState.authenticated(result.user, message: result.message));
    } else if (result is AuthFailure) {
      // Check if the user cancelled the sign-in - Don't show error; return to previous state
      if (result.message.toLowerCase().contains('cancelled')) {
        final currentUser = _authRepository.currentUser;
        if (currentUser != null) {
          emit(AuthState.authenticated(currentUser));
        } else {
          emit(AuthState.unauthenticated());
        }
      } else {
        emit(AuthState.unauthenticated(error: result.message));
      }
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.passwordResetLoading());

    final result = await _authRepository.sendPasswordResetEmail(event.email);

    if (result is AuthSuccess) {
      // Show success message temporarily, then return to unauthenticated
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          message: result.message,
        ),
      );

      // Clear message after a delay
      await Future.delayed(const Duration(seconds: 3));
      emit(AuthState.unauthenticated());
    } else if (result is AuthFailure) {
      emit(AuthState.unauthenticated(error: result.message));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    final result = await _authRepository.signOut();

    if (result is AuthSuccess) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          message: result.message,
        ),
      );

      // Clear message after a delay
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthState.unauthenticated());
    } else if (result is AuthFailure) {
      emit(AuthState.unauthenticated(error: result.message));
    }
  }

  Future<void> _onUpdateDisplayNameRequested(
    UpdateDisplayNameRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(error: 'No authenticated user found'));
      return;
    }

    emit(AuthState.loading());

    final updatedUser = state.user!.copyWith(fullName: event.displayName);
    final result = await _authRepository.updateUserProfile(updatedUser);

    if (result is AuthSuccess) {
      emit(AuthState.authenticated(result.user, message: result.message));
    } else if (result is AuthFailure) {
      emit(state.copyWith(error: result.message));
    }
  }

  Future<void> _onUpdateEmailRequested(
    UpdateEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(error: 'No authenticated user found'));
      return;
    }
    emit(AuthState.loading());

    final updatedUser = state.user!.copyWith(email: event.newEmail);
    final result = await _authRepository.updateUserProfile(updatedUser);

    if (result is AuthSuccess) {
      emit(AuthState.authenticated(result.user, message: result.message));
    } else if (result is AuthFailure) {
      emit(state.copyWith(error: result.message));
    }
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    final result = await _authRepository.deleteAccount();

    if (result is AuthSuccess) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          message: result.message,
        ),
      );
    } else if (result is AuthFailure) {
      emit(state.copyWith(error: result.message));
    }
  }

  @override
  Future<void> close() {
    _userStreamSubscription?.cancel();
    return super.close();
  }
}
