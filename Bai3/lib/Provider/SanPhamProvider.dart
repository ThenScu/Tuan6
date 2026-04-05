import 'package:flutter/material.dart';
import '../Database/db_helper.dart';
import '../Model/SanPham.dart';

class SanPhamProvider with ChangeNotifier {
  List<SanPham> _listSP = [];
  List<SanPham> get listSP => _listSP;

  // Lấy dữ liệu từ DB
  Future<void> fetchSanPhams() async {
    _listSP = await DatabaseHelper.instance.getAll();
    notifyListeners();
  }

  // Thêm sản phẩm
  Future<void> addSanPham(SanPham sp) async {
    await DatabaseHelper.instance.insert(sp);
    await fetchSanPhams(); // Cập nhật lại list sau khi thêm
  }
}