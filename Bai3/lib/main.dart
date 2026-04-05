import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/SanPhamProvider.dart';
import 'Model/SanPham.dart';

void main() {
  // Đảm bảo các plugin (như sqflite) được khởi tạo đúng cách trước khi chạy app
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Bọc Provider ở ngoài cùng để toàn bộ app có thể xài data
    ChangeNotifierProvider(
      create: (_) => SanPhamProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Sản phẩm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SanPhamScreen(),
    );
  }
}

class SanPhamScreen extends StatelessWidget {
  const SanPhamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe dữ liệu từ Provider
    final provider = Provider.of<SanPhamProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Sản phẩm'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        // Tự động load dữ liệu khi mở app
        future: provider.fetchSanPhams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && provider.listSP.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.listSP.isEmpty) {
            return const Center(child: Text('Chưa có sản phẩm nào, bấm nút + để thêm'));
          }

          return ListView.builder(
            itemCount: provider.listSP.length,
            itemBuilder: (context, index) {
              final sp = provider.listSP[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(child: Text(sp.ma)),
                  title: Text(sp.ten, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Giá: ${sp.gia} | Thuế NK: ${sp.thueNhapKhau}'),
                  trailing: Text('-${sp.giamGia}', style: const TextStyle(color: Colors.red)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mockup dữ liệu để test, sau này bro làm cái Dialog nhập liệu là xịn luôn
          final newSP = SanPham(
            ma: 'SP0${provider.listSP.length + 1}',
            ten: 'Sản phẩm ${provider.listSP.length + 1}',
            gia: 1000.0,
            giamGia: 100.0,
          );
          provider.addSanPham(newSP);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}