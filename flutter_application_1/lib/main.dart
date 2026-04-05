import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/SinhVienProvider.dart';
import '../Screens/Bai1.dart';

void main() {
  runApp(
    // Bọc Provider ở ngoài cùng để cả app (kể cả bài 1) đều xài được Database
    ChangeNotifierProvider(
      create: (context) => SinhVienProvider()..loadSinhViens(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // Trang mở lên đầu tiên là Menu
    );
  }
}

// --- GIAO DIỆN MENU TỔNG ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Tổng Hợp Bài Tập'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Nút đi đến Bài 1
          _buildMenuButton(
            context,
            title: 'Bài Tập 1: Quản lý Sinh Viên',
            destination: const Bai1Screen(), // Chuyển sang class Bai1Screen khi bấm
          ),
          const SizedBox(height: 15),

          // Nút mẫu cho Bài 2 (Bro tự tạo màn hình bài 2 rồi thay thế vào nhé)
          _buildMenuButton(
            context,
            title: 'Bài Tập 2: (Đang cập nhật)',
            destination: const Scaffold(body: Center(child: Text("Giao diện bài 2"))),
          ),
        ],
      ),
    );
  }

  // Hàm vẽ nút bấm cực gọn
  Widget _buildMenuButton(BuildContext context, {required String title, required Widget destination}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        backgroundColor: Colors.purple.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        // Lệnh điều hướng sang trang khác
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.purple, size: 18),
        ],
      ),
    );
  }
}