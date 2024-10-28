class Note {
  String? id;
  String title;
  String content;
  String userId; // The ID of the user this note belongs to

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'userId': userId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      title: map['title'],
      content: map['content'],
      userId: map['userId'],
    );
  }
}
