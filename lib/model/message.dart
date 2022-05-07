class MMessage {
  final int id;
  final String content;
  final String insertedAt;

  MMessage({
    required this.id,
    required this.content,
    required this.insertedAt,
  });

  factory MMessage.fromJSON(Map<String, dynamic> json) {
    return MMessage(
      id: json['id'],
      content: json['content'],
      insertedAt: json['inserted_at'],
    );
  }
}
