import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import 'ChiTieuScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _hienThongBao(String thongBao, Color mau) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(thongBao), backgroundColor: mau),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),
                  const Text('APP QUẢN LÝ TIỀN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Thêm chữ async/await để đợi DB xử lý
                          bool success = await provider.dangNhap(_emailCtrl.text, _passCtrl.text);
                          if (!mounted) return; // Tránh lỗi context

                          if (success) {
                            _hienThongBao('Đăng nhập thành công!', Colors.green);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChiTieuScreen()));
                          } else {
                            _hienThongBao('Sai email hoặc mật khẩu!', Colors.red);
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
                            _hienThongBao('Vui lòng nhập đủ thông tin!', Colors.orange);
                            return;
                          }

                          bool success = await provider.dangKy(_emailCtrl.text, _passCtrl.text);
                          if (!mounted) return;

                          if (success) {
                            _hienThongBao('Đăng ký thành công! Hãy bấm Sign In.', Colors.green);
                          } else {
                            _hienThongBao('Tài khoản đã tồn tại!', Colors.red);
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}