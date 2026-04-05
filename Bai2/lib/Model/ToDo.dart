class TodoItem {
  final int? id;
  final String title;
  final String content;
  final bool isCompleted;

  TodoItem({
    this.id,
    required this.title,
    required this.content,
    this.isCompleted = false,
  });

  // Chuyển sang Map để đưa vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isCompleted': isCompleted ? 1 : 0, // SQLite dùng 1 và 0
    };
  }

  // Lấy từ SQLite ra
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}