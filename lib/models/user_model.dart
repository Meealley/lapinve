// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String? fullName;
  final String? photoUrl;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? driverLicenseNumber;
  final String? driverLicensePhotoUrl;
  final String? idVerificationPhotoUrl;
  final String? selfiePhotoUrl;
  final String? address;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isIdVerified;
  final bool canRentCars; // Stage 2 verification complete
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.email,
    this.fullName,
    this.photoUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.driverLicenseNumber,
    this.driverLicensePhotoUrl,
    this.idVerificationPhotoUrl,
    this.selfiePhotoUrl,
    this.address,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isIdVerified = false,
    this.canRentCars = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      uid,
      email,
      fullName,
      photoUrl,
      phoneNumber,
      dateOfBirth,
      driverLicenseNumber,
      driverLicensePhotoUrl,
      idVerificationPhotoUrl,
      selfiePhotoUrl,
      address,
      isEmailVerified,
      isPhoneVerified,
      isIdVerified,
      canRentCars,
      createdAt,
      updatedAt,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'driverLicenseNumber': driverLicenseNumber,
      'driverLicensePhotoUrl': driverLicensePhotoUrl,
      'idVerificationPhotoUrl': idVerificationPhotoUrl,
      'selfiePhotoUrl': selfiePhotoUrl,
      'address': address,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isIdVerified': isIdVerified,
      'canRentCars': canRentCars,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  static UserModel placeholder() {
    return UserModel(
      uid: '',
      email: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      phoneNumber: map['phoneNumber'] != null
          ? map['phoneNumber'] as String
          : null,
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int)
          : null,
      driverLicenseNumber: map['driverLicenseNumber'] != null
          ? map['driverLicenseNumber'] as String
          : null,
      driverLicensePhotoUrl: map['driverLicensePhotoUrl'] != null
          ? map['driverLicensePhotoUrl'] as String
          : null,
      idVerificationPhotoUrl: map['idVerificationPhotoUrl'] != null
          ? map['idVerificationPhotoUrl'] as String
          : null,
      selfiePhotoUrl: map['selfiePhotoUrl'] != null
          ? map['selfiePhotoUrl'] as String
          : null,
      address: map['address'] != null ? map['address'] as String : null,
      isEmailVerified: map['isEmailVerified'] as bool,
      isPhoneVerified: map['isPhoneVerified'] as bool,
      isIdVerified: map['isIdVerified'] as bool,
      canRentCars: map['canRentCars'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? photoUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? driverLicenseNumber,
    String? driverLicensePhotoUrl,
    String? idVerificationPhotoUrl,
    String? selfiePhotoUrl,
    String? address,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isIdVerified,
    bool? canRentCars,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      driverLicenseNumber: driverLicenseNumber ?? this.driverLicenseNumber,
      driverLicensePhotoUrl:
          driverLicensePhotoUrl ?? this.driverLicensePhotoUrl,
      idVerificationPhotoUrl:
          idVerificationPhotoUrl ?? this.idVerificationPhotoUrl,
      selfiePhotoUrl: selfiePhotoUrl ?? this.selfiePhotoUrl,
      address: address ?? this.address,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isIdVerified: isIdVerified ?? this.isIdVerified,
      canRentCars: canRentCars ?? this.canRentCars,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
