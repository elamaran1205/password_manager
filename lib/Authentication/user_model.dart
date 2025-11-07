class UserModel {
  final String photoUrl;
  final String email;
  final String name;
  final String uid;

  UserModel({
    required this.photoUrl,
    required this.email,
    required this.name,
    required this.uid,
  });
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email, 'photoUrl': photoUrl};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }
}
