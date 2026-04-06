import 'package:flutter/material.dart';
import '../Model/ChiTieu.dart';
import '../Database/db_helper.dart';

class AppProvider extends ChangeNotifier {
  List<ChiTieu> danhSachChiTieu = [];

  Future<void> loadChiTieu() async {
    danhSachChiTieu = await DatabaseHelper.instance.getAllChiTieu();
    notifyListeners();
  }

  Future<bool> dangNhap(String email, String pass) async {
    bool isSuccess = await DatabaseHelper.instance.checkLogin(email, pass);
    if (isSuccess) {
      await loadChiTieu(); // Load dữ liệu khi đăng nhập thành công
    }
    return isSuccess;
  }

  Future<bool> dangKy(String email, String pass) async {
    return await DatabaseHelper.instance.register(email, pass);
  }

  Future<void> themChiTieu(ChiTieu ct) async {
    await DatabaseHelper.instance.insertChiTieu(ct);
    await loadChiTieu();
  }
}