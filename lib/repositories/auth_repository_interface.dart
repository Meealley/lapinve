import 'package:lapinve/models/auth_result.dart';
import 'package:lapinve/models/user_model.dart';

abstract class AuthRepositoryInterface {
  // Get current user stream
  Stream<UserModel?> get userStream;

  // Current user getter
  UserModel? get currentUser;

  // Email & Password Authentication
  Future<UserModel> signUpWithEmailAndPassword(SignUpData signUpData);
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Social Authentication
  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> signInWithApple();

  // Password Reset
  Future<AuthResult> sendPasswordResetEmail(String email);

  // Sign Out
  Future<AuthResult> signOut();

  // Profile Update (Stage 2)
  Future<AuthResult> updateUserProfile(UserModel updatedUser);
  Future<AuthResult> updatePhoneNumber(String phoneNumber);
  Future<AuthResult> verifyPhoneNumber(String verificationCode);
  Future<AuthResult> uploadDriverLicense(
    String licenseNumber,
    String photoPath,
  );
  Future<AuthResult> uploadIdVerification(String photoUrl);
  Future<AuthResult> uploadSelfie(String photoUrl);
  Future<AuthResult> updateAddress(String address);
  Future<AuthResult> updateDateOfBirth(DateTime dateOfBirth);

  // Account Deletion
  Future<AuthResult> deleteAccount();
}
