class SinhVien {
  final int? id;
  final String name;
  final String email;

  SinhVien({this.id, required this.name, required this.email});

  // Ép kiểu từ Object sang Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Ép kiểu từ Map (từ SQLite) sang Object
  factory SinhVien.fromMap(Map<String, dynamic> map) {
    return SinhVien(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}