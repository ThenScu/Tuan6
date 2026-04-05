import 'package:flutter/material.dart';
import '../Database/db_helper.dart';
import '../Model/SinhVien.dart';

class SinhVienProvider extends ChangeNotifier {
  List<SinhVien> _sinhViens = [];
  List<SinhVien> _filteredSinhViens = []; // Dùng cho chức năng tìm kiếm

  // Getter trả về danh sách đã được lọc (hiển thị lên UI)
  List<SinhVien> get sinhViens => _filteredSinhViens.isEmpty && _searchQuery.isEmpty
      ? _sinhViens
      : _filteredSinhViens;

  String _searchQuery = '';

  // Load toàn bộ từ SQLite
  Future<void> loadSinhViens() async {
    _sinhViens = await DatabaseHelper.instance.getSinhViens();
    _filteredSinhViens = List.from(_sinhViens);
    notifyListeners(); // Báo cho UI tự cập nhật
  }

  // Thêm mới
  Future<void> addSinhVien(SinhVien sv) async {
    await DatabaseHelper.instance.insertSinhVien(sv);
    loadSinhViens(); // Load lại list sau khi thêm
  }

  // Xóa
  Future<void> deleteSinhVien(int id) async {
    await DatabaseHelper.instance.deleteSinhVien(id);
    loadSinhViens();
  }

  // Cập nhật
  Future<void> updateSinhVien(SinhVien sv) async {
    await DatabaseHelper.instance.updateSinhVien(sv);
    loadSinhViens();
  }

  // Tìm kiếm
  void searchSinhVien(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredSinhViens = List.from(_sinhViens);
    } else {
      _filteredSinhViens = _sinhViens
          .where((sv) => sv.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}