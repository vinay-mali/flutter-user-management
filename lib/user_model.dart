class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String? fatherName;
  final int age;
  final String? photo;

  UserModel({
    required this.fullName,
    required this.email,
    this.fatherName,
    required this.age,
    this.photo,
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      fullName: json['fullName'],
      email: json['email'],
      fatherName: json['fatherName'],
      age: json['age'],
      photo: json['photo'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'fatherName': fatherName,
      'age': age,
      'photo': photo,
    };
  }
}
