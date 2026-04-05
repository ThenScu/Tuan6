import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/SinhVien.dart';
import '../Provider/SinhVienProvider.dart';

class Bai1Screen extends StatelessWidget {
  const Bai1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SinhVienProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F3), // Màu nền giống ảnh
      appBar: AppBar(
        title: const Text('Quản lý Sinh Viên'),
        backgroundColor: Colors.purple.shade200,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- Thanh tìm kiếm ---
              TextField(
                onChanged: (value) => provider.searchSinhVien(value),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sinh viên...',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.close),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Danh sách Sinh Viên ---
              Expanded(
                child: ListView.builder(
                  itemCount: provider.sinhViens.length,
                  itemBuilder: (context, index) {
                    final sv = provider.sinhViens[index];
                    return Card(
                      color: const Color(0xFF9E9E9E), // Nền xám
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.blue),
                        ),
                        title: Text(
                          sv.name,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          sv.email,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            provider.deleteSinhVien(sv.id!);
                          },
                        ),
                        // Bấm vào item để mở Dialog cập nhật
                        onTap: () => _showSinhVienDialog(context, provider, sv: sv),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // --- Nút thêm ở góc dưới ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE1BEE7), // Tím nhạt
        onPressed: () => _showSinhVienDialog(context, provider),
        child: const Icon(Icons.add, color: Colors.purple),
      ),
    );
  }

  // --- Hàm show Dialog chung cho cả Thêm và Sửa ---
  void _showSinhVienDialog(BuildContext context, SinhVienProvider provider, {SinhVien? sv}) {
    final isUpdate = sv != null;
    final nameController = TextEditingController(text: isUpdate ? sv.name : '');
    final emailController = TextEditingController(text: isUpdate ? sv.email : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdate ? "Thông tin chi tiết của sinh viên" : "Thêm Sinh Viên"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Tên Sinh Viên"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy", style: TextStyle(color: Colors.purple)),
            ),
            TextButton(
              onPressed: () {
                String name = nameController.text.trim();
                String email = emailController.text.trim();

                if (name.isNotEmpty && email.isNotEmpty) {
                  if (isUpdate) {
                    provider.updateSinhVien(SinhVien(id: sv.id, name: name, email: email));
                  } else {
                    provider.addSinhVien(SinhVien(name: name, email: email));
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(isUpdate ? "Cập nhật" : "Lưu", style: const TextStyle(color: Colors.purple)),
            ),
          ],
        );
      },
    );
  }
}