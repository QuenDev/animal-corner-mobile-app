class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String? imagePath;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phone = '',
    this.address = '',
    this.imagePath,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['owner_phone'] ?? '',
      address: map['owner_address'] ?? '',
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'owner_phone': phone,
      'owner_address': address,
      'imagePath': imagePath,
    };
  }
}
