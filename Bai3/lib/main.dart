import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/SanPhamProvider.dart';
import 'Model/SanPham.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SanPhamProvider()..fetchSanPhams(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản Lý Sản Phẩm',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const QuanLySanPhamScreen(),
    );
  }
}

class QuanLySanPhamScreen extends StatelessWidget {
  const QuanLySanPhamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gọi Provider để lấy danh sách
    final provider = Provider.of<SanPhamProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Quản Lý Sản Phẩm', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: provider.listSP.isEmpty
          ? const Center(child: Text("Chưa có sản phẩm nào trong Database!"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.listSP.length,
        itemBuilder: (context, index) {
          final sp = provider.listSP[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[${sp.ma}] ${sp.ten}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const Divider(),
                  Text('Đơn giá: ${sp.gia} VNĐ'),
                  Text('Giảm giá: ${sp.giamGia} VNĐ', style: const TextStyle(color: Colors.orange)),
                  const SizedBox(height: 8),
                  // Gọi phương thức thueNhapKhau từ Model của bro
                  Text(
                    'Thuế nhập khẩu (10%): ${sp.thueNhapKhau} VNĐ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showDialogThem(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Hàm hiển thị để nhập thông tin Sản Phẩm
  void _showDialogThem(BuildContext context) {
    final maCtrl = TextEditingController();
    final tenCtrl = TextEditingController();
    final giaCtrl = TextEditingController();
    final giamGiaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm Sản Phẩm'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: maCtrl, decoration: const InputDecoration(labelText: 'Mã SP (Không trùng)')),
                TextField(controller: tenCtrl, decoration: const InputDecoration(labelText: 'Tên Sản Phẩm')),
                TextField(controller: giaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Đơn Giá')),
                TextField(controller: giamGiaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Giảm Giá')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lấy dữ liệu và ép kiểu
                double gia = double.tryParse(giaCtrl.text) ?? 0.0;
                double giam = double.tryParse(giamGiaCtrl.text) ?? 0.0;
                String ma = maCtrl.text.trim();
                String ten = tenCtrl.text.trim();

                if (ma.isNotEmpty && ten.isNotEmpty) {
                  // Tạo Object SanPham
                  final spMoi = SanPham(ma: ma, ten: ten, gia: gia, giamGia: giam);

                  // Gọi Provider để lưu vào DB
                  context.read<SanPhamProvider>().addSanPham(spMoi);

                  Navigator.pop(context);
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}