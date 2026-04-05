class SanPham {
  String ma;
  String ten;
  double gia;
  double giamGia;

  SanPham({required this.ma, required this.ten, required this.gia, required this.giamGia});

  // Tính thuế 10%
  double get thueNhapKhau => gia * 0.1;

  // Chuyển Map từ DB thành Object
  factory SanPham.fromMap(Map<String, dynamic> json) => SanPham(
    ma: json['ma'],
    ten: json['ten'],
    gia: json['gia'],
    giamGia: json['giamGia'],
  );

  // Chuyển Object thành Map để lưu DB
  Map<String, dynamic> toMap() {
    return {
      'ma': ma,
      'ten': ten,
      'gia': gia,
      'giamGia': giamGia,
    };
  }
}