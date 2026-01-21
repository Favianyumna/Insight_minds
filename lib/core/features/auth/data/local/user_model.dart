import 'package:hive/hive.dart';

@HiveType(typeId: 12)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password; // In production, this should be hashed

  @HiveField(3)
  String fullName;

  @HiveField(4)
  String? phoneNumber;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? lastLoginAt;

  @HiveField(7)
  String? profileImagePath;

  @HiveField(8)
  String? bio;

  @HiveField(9)
  int? age;

  @HiveField(10)
  String? gender;

  @HiveField(11)
  bool isEmailVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    this.phoneNumber,
    required this.createdAt,
    this.lastLoginAt,
    this.profileImagePath,
    this.bio,
    this.age,
    this.gender,
    this.isEmailVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'profileImagePath': profileImagePath,
      'bio': bio,
      'age': age,
      'gender': gender,
      'isEmailVerified': isEmailVerified,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      profileImagePath: json['profileImagePath'] as String?,
      bio: json['bio'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );
  }
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 12;

  @override
  UserModel read(BinaryReader reader) {
    final id = reader.readString();
    final email = reader.readString();
    final password = reader.readString();
    final fullName = reader.readString();
    final phoneNumberStr = reader.readString();
    final createdAtStr = reader.readString();
    final lastLoginAtStr = reader.readString();
    final profileImagePathStr = reader.readString();
    final bioStr = reader.readString();
    final ageInt = reader.readInt();
    final genderStr = reader.readString();
    final isEmailVerified = reader.readBool();

    return UserModel(
      id: id,
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumberStr.isEmpty ? null : phoneNumberStr,
      createdAt: DateTime.parse(createdAtStr),
      lastLoginAt: lastLoginAtStr.isEmpty ? null : DateTime.parse(lastLoginAtStr),
      profileImagePath: profileImagePathStr.isEmpty ? null : profileImagePathStr,
      bio: bioStr.isEmpty ? null : bioStr,
      age: ageInt == -1 ? null : ageInt,
      gender: genderStr.isEmpty ? null : genderStr,
      isEmailVerified: isEmailVerified,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.email);
    writer.writeString(obj.password);
    writer.writeString(obj.fullName);
    writer.writeString(obj.phoneNumber ?? '');
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeString(obj.lastLoginAt?.toIso8601String() ?? '');
    writer.writeString(obj.profileImagePath ?? '');
    writer.writeString(obj.bio ?? '');
    writer.writeInt(obj.age ?? -1);
    writer.writeString(obj.gender ?? '');
    writer.writeBool(obj.isEmailVerified);
  }
}
