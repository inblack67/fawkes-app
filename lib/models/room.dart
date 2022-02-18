class Room {
  final int id;
  final String name;
  final String desc;
  final String insertedAt;

  Room({
    required this.id,
    required this.name,
    required this.desc,
    required this.insertedAt,
  });

  factory Room.fromJSON(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      insertedAt: json['inserted_at'],
    );
  }
}
