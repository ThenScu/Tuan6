import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import '../Model/ChiTieu.dart';
import 'LoginScreen.dart';

class ChiTieuScreen extends StatelessWidget {
  const ChiTieuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Sử Chi Tiêu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: provider.danhSachChiTieu.isEmpty
          ? const Center(child: Text("Hôm nay chưa tiêu đồng nào! Quá giỏi!"))
          : ListView.builder(
        itemCount: provider.danhSachChiTieu.length,
        itemBuilder: (context, index) {
          final ct = provider.danhSachChiTieu[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.money_off, color: Colors.redAccent),
              title: Text(ct.noiDung, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Ghi chú: ${ct.ghiChu}'),
              trailing: Text('-${ct.soTien} VNĐ', style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showDialogThem(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDialogThem(BuildContext context) {
    final noiDungCtrl = TextEditingController();
    final tienCtrl = TextEditingController();
    final ghiChuCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm khoản chi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: noiDungCtrl, decoration: const InputDecoration(labelText: 'Nội dung (vd: Mua sắm)')),
              TextField(controller: tienCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Số tiền')),
              TextField(controller: ghiChuCtrl, decoration: const InputDecoration(labelText: 'Ghi chú')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () async { // Thêm async
                double tien = double.tryParse(tienCtrl.text) ?? 0.0;
                if (noiDungCtrl.text.isNotEmpty && tien > 0) {
                  // Đợi DB thêm xong mới đóng form
                  await context.read<AppProvider>().themChiTieu(
                    ChiTieu(noiDung: noiDungCtrl.text, soTien: tien, ghiChu: ghiChuCtrl.text),
                  );
                  if (context.mounted) Navigator.pop(context);
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