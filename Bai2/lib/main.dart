import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Model/Todo.dart';
import 'Provider/TodoProvider.dart';

void main() {
  runApp(
    // Bọc Provider ở ngoài cùng để quản lý trạng thái
    ChangeNotifierProvider(
      create: (context) => TodoProvider()..loadTodos(),
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
      home: TodoScreen(), // Chạy thẳng vào màn hình Todo
    );
  }
}

// --- MÀN HÌNH DANH SÁCH CÔNG VIỆC ---
class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Todo', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: provider.todos.length,
          itemBuilder: (context, index) {
            final todo = provider.todos[index];
            return Card(
              color: const Color(0xFFF3E5F5), // Nền tím nhạt
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.blueAccent, width: 0.5),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          todo.title,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => provider.deleteTodo(todo.id!),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: todo.isCompleted,
                          onChanged: (value) => provider.toggleTodoStatus(todo),
                          activeColor: Colors.deepPurple,
                        ),
                        Text(
                          todo.isCompleted ? "Hoàn thành" : "Chưa hoàn thành",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // Nút nổi mở màn hình thêm
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE1BEE7),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.purple),
      ),
    );
  }
}

// --- MÀN HÌNH THÊM CÔNG VIỆC MỚI ---
class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add New Todo', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.grey),
            onPressed: () {
              final title = _titleController.text.trim();
              final content = _contentController.text.trim();

              if (title.isNotEmpty && content.isNotEmpty) {
                // Lưu vào Database thông qua Provider
                context.read<TodoProvider>().addTodo(
                  TodoItem(title: title, content: content),
                );
                Navigator.pop(context); // Trở về màn hình trước
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Content',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}