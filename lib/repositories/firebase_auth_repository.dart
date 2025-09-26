// lib/repositories/firebase_auth_repository.dart - Fixed version

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lapinve/models/auth_result.dart';
import 'package:lapinve/models/user_model.dart';
import 'package:lapinve/repositories/auth_repository_interface.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthRepository implements AuthRepositoryInterface {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final String _usersCollection = 'users';

  // Stream controller for user data
  StreamController<UserModel?>? _userStreamController;
  StreamSubscription<User?>? _authStreamSubscription;
  StreamSubscription<DocumentSnapshot>? _userDocStreamSubscription;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn() {
    _initializeUserStream();
  }

  @override
  void dispose() {
    _userStreamController?.close();
    _authStreamSubscription?.cancel();
    _userDocStreamSubscription?.cancel();
  }

  void _initializeUserStream() {
    _userStreamController = StreamController<UserModel?>.broadcast();

    _authStreamSubscription = _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        // User is signed in, listen to their Firestore document
        _userDocStreamSubscription
            ?.cancel(); // Cancel any existing subscription
        _userDocStreamSubscription = _firestore
            .collection(_usersCollection)
            .doc(user.uid)
            .snapshots()
            .listen((doc) {
              if (doc.exists) {
                final userData = doc.data()!;
                final userModel = UserModel.fromMap(userData);
                _userStreamController?.add(userModel);
              } else {
                _userStreamController?.add(null);
              }
            });
      } else {
        // User is signed out
        _userDocStreamSubscription?.cancel();
        _userStreamController?.add(null);
      }
    });
  }

  @override
  Stream<UserModel?> get userStream => _userStreamController!.stream;

  @override
  UserModel? get currentUser {
    return null;
  }

  @override
  Future<AuthResult> signUpWithEmailAndPassword(SignUpData signUpData) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: signUpData.email.trim(),
            password: signUpData.password!,
          );

      if (userCredential.user == null) {
        return const AuthFailure(message: 'Failed to create user account');
      }

      // Update Firebase Auth display name
      await userCredential.user!.updateDisplayName(signUpData.fullName.trim());
      await userCredential.user!.reload();

      // Create UserModel for Stage 1
      final now = DateTime.now();
      final userModel = UserModel(
        uid: userCredential.user!.uid,
        email: signUpData.email.trim(),
        fullName: signUpData.fullName.trim(),
        photoUrl: userCredential.user!.photoURL,
        isEmailVerified: userCredential.user!.emailVerified,
        createdAt: now,
        updatedAt: now,
      );

      // Save to Firestore
      await _firestore
          .collection(_usersCollection)
          .doc(userModel.uid)
          .set(userModel.toMap());

      return AuthSuccess(
        user: userModel,
        message: 'Account created successfully! You can now browse cars.',
      );
    } on FirebaseAuthException catch (e) {
      return AuthFailure(message: _getFirebaseErrorMessage(e), code: e.code);
    } catch (e) {
      return AuthFailure(
        message: 'An unexpected error occurred during signup: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      if (userCredential.user == null) {
        return const AuthFailure(message: "Failed to sign in");
      }

      // Get user data from Firestore
      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        return const AuthFailure(message: "User data not found");
      }

      final userModel = UserModel.fromMap(userDoc.data()!);

      return AuthSuccess(user: userModel, message: "Welcome back!");
    } on FirebaseAuthException catch (e) {
      return AuthFailure(message: _getFirebaseErrorMessage(e), code: e.code);
    } catch (e) {
      return AuthFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      );
    }
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Sign out from previous Google sessions to allow account selection
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return const AuthFailure(message: "Google sign-in was cancelled");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        return const AuthFailure(message: "Failed to sign in with Google");
      }

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      final firebaseUser = userCredential.user!;

      UserModel userModel;
      String message;

      if (isNewUser) {
        // Create new document for Stage 1
        final now = DateTime.now();
        userModel = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          fullName: firebaseUser.displayName ?? '',
          photoUrl: firebaseUser.photoURL,
          isEmailVerified: firebaseUser.emailVerified,
          createdAt: now,
          updatedAt: now,
        );

        await _firestore
            .collection(_usersCollection)
            .doc(userModel.uid)
            .set(userModel.toMap());

        message =
            'Account created successfully with Google! You can now browse cars.';
      } else {
        // Get existing user data
        final userDoc = await _firestore
            .collection(_usersCollection)
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) {
          return const AuthFailure(message: 'User data not found');
        }
        userModel = UserModel.fromMap(userDoc.data()!);
        message = 'Welcome back!';
      }
      return AuthSuccess(user: userModel, message: message);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(message: _getFirebaseErrorMessage(e), code: e.code);
    } catch (e) {
      return AuthFailure(message: "Google Sign in failed: ${e.toString()}");
    }
  }

  @override
  Future<AuthResult> signInWithApple() async {
    try {
      // Generate nonce for additional security
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential = OAuthProvider(
        "apple.com",
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

      // Sign in the user with Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        return const AuthFailure(message: 'Failed to sign in with Apple');
      }

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      final firebaseUser = userCredential.user!;

      UserModel userModel;
      String message;

      if (isNewUser) {
        final fullName = _buildFullName(
          appleCredential.givenName,
          appleCredential.familyName,
        );

        // Update display name if available
        if (fullName.isNotEmpty) {
          await firebaseUser.updateDisplayName(fullName);
          await firebaseUser.reload();
        }

        // Create new user document for Stage 1
        final now = DateTime.now();
        userModel = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          fullName: fullName,
          photoUrl: firebaseUser.photoURL,
          isEmailVerified: firebaseUser.emailVerified,
          createdAt: now,
          updatedAt: now,
        );

        await _firestore
            .collection(_usersCollection)
            .doc(userModel.uid)
            .set(userModel.toMap());

        message =
            'Account created successfully with Apple! You can now browse cars.';
      } else {
        // Get existing user data
        final userDoc = await _firestore
            .collection(_usersCollection)
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) {
          return const AuthFailure(message: 'User data not found');
        }

        userModel = UserModel.fromMap(userDoc.data()!);
        message = 'Welcome back!';
      }

      return AuthSuccess(user: userModel, message: message);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(message: _getFirebaseErrorMessage(e), code: e.code);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return const AuthFailure(message: 'Apple sign-in was cancelled');
      }
      return AuthFailure(message: 'Apple sign-in failed: ${e.toString()}');
    } catch (e) {
      return AuthFailure(message: 'Apple sign-in failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      // Return success without user data since password reset doesn't need it
      return AuthSuccess(
        user: UserModel.placeholder(), // Use the placeholder method
        message: 'Password reset email sent successfully',
      );
    } on FirebaseAuthException catch (e) {
      return AuthFailure(message: _getFirebaseErrorMessage(e), code: e.code);
    } catch (e) {
      return AuthFailure(
        message: 'Failed to send password reset email: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResult> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);

      return AuthSuccess(
        user: UserModel.placeholder(), // Use the placeholder method
        message: 'Signed out successfully',
      );
    } catch (e) {
      return AuthFailure(message: 'Failed to sign out: ${e.toString()}');
    }
  }

  // Stage 2 Methods
  @override
  Future<AuthResult> updateUserProfile(UserModel updatedUser) async {
    try {
      final currentFirebaseUser = _firebaseAuth.currentUser;
      if (currentFirebaseUser == null) {
        return const AuthFailure(message: 'No authenticated user found');
      }

      final userToUpdate = updatedUser.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection(_usersCollection)
          .doc(currentFirebaseUser.uid)
          .update(userToUpdate.toMap());

      return AuthSuccess(
        user: userToUpdate,
        message: 'Profile updated successfully',
      );
    } catch (e) {
      return AuthFailure(message: 'Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> updatePhoneNumber(String phoneNumber) async {
    // Implementation depends on your phone verification flow
    // This is a placeholder
    return const AuthFailure(
      message: 'Phone number update not implemented yet',
    );
  }

  @override
  Future<AuthResult> verifyPhoneNumber(String verificationCode) async {
    // Implementation depends on your phone verification flow
    // This is a placeholder
    return const AuthFailure(message: 'Phone verification not implemented yet');
  }

  @override
  Future<AuthResult> uploadDriverLicense(
    String licenseNumber,
    String photoUrl,
  ) async {
    try {
      final currentFirebaseUser = _firebaseAuth.currentUser;
      if (currentFirebaseUser == null) {
        return const AuthFailure(message: 'No authenticated user found');
      }

      await _firestore
          .collection(_usersCollection)
          .doc(currentFirebaseUser.uid)
          .update({
            'driverLicenseNumber': licenseNumber,
            'driverLicensePhotoUrl': photoUrl,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      return AuthSuccess(
        user: UserModel.placeholder(), // Use the placeholder method
        message: 'Driver license uploaded successfully',
      );
    } catch (e) {
      return AuthFailure(
        message: 'Failed to upload driver license: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResult> uploadIdVerification(String photoUrl) async {
    try {
      final currentFirebaseUser = _firebaseAuth.currentUser;
      if (currentFirebaseUser == null) {
        return const AuthFailure(message: 'No authenticated user found');
      }

      await _firestore
          .collection(_usersCollection)
          .doc(currentFirebaseUser.uid)
          .update({
            'idVerificationPhotoUrl': photoUrl,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      return AuthSuccess(
        user: UserModel.placeholder(), // Use the placeholder method
        message: 'ID verification uploaded successfully',
      );
    } catch (e) {
      return AuthFailure(
        message: 'Failed to upload ID verification: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResult> uploadSelfie(String photoUrl) async {
    try {
      final currentFirebaseUser = _firebaseAuth.currentUser;
      if (currentFirebaseUser == null) {
        return const AuthFailure(message: 'No authenticated user found');
      }

      await _firestore
          .collection(_usersCollection)
          .doc(currentFirebaseUser.uid)
          .update({
            'selfiePhotoUrl': photoUrl,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      return AuthSuccess(
        user: UserModel.placeholder(), // Use the placeholder method
        message: 'Selfie uploaded successfully',
      );
    } catch (e) {
      return AuthFailure(message: 'Failed to upload selfie: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> updateAddress(String address) async {
    try {
      final currentFirebaseUser = _firebaseAuth.currentUser;
      if (currentFirebaseUser == null) {
        return const AuthFailure(message: 'No authenticated user found');
      }

      await _firestore
          .collection(_usersCollection)
          .doc(currentFirebaseUser.uid)
          .update({
            'address': address,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      return AuthSuccess(
        user: UserModel.placeholder(), // Use the placeholder method
        message: 'Address updated successfully',
      );
    } catch (e) {
      return AuthFailure(message: 'Failed to update address: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> updateDateOfBirth(DateTime dateOfBirth) async {
    try {
      final currentFirebaseUser = _firebaseAuth.currentUser;
      if (currentFirebaseUser == null) {
        return const AuthFailure(message: 'No authenticated user found');
      }

      await _firestore
          .collection(_usersCollection)
          .doc(currentFirebaseUser.uid)
          .update({
            'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      return AuthSuccess(
        user: UserModel.placeholder(), // Use the placeholder method
        message: 'Date of birth updated successfully',
      );
    } catch (e) {
      return AuthFailure(
        message: 'Failed to update date of birth: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResult> deleteAccount() async {
    try {
      final currentFirebaseUser = _firebaseAuth.currentUser;
      if (currentFirebaseUser == null) {
        return const AuthFailure(message: 'No authenticated user found');
      }

      // Delete user document from Firestore
      await _firestore
          .collection(_usersCollection)
          .doc(currentFirebaseUser.uid)
          .delete();

      // Delete Firebase Auth user
      await currentFirebaseUser.delete();

      return AuthSuccess(
        user: UserModel.placeholder(), // Use the placeholder method
        message: 'Account deleted successfully',
      );
    } on FirebaseAuthException catch (e) {
      return AuthFailure(message: _getFirebaseErrorMessage(e), code: e.code);
    } catch (e) {
      return AuthFailure(message: 'Failed to delete account: ${e.toString()}');
    }
  }

  // Private helper methods
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _buildFullName(String? firstName, String? lastName) {
    if (firstName == null && lastName == null) return '';
    if (firstName == null) return lastName!;
    if (lastName == null) return firstName;
    return '$firstName $lastName';
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'requires-recent-login':
        return 'Please sign in again to perform this action.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
