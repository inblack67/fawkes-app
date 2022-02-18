class MRoom {
  final int id;
  final String name;
  final String desc;
  final String insertedAt;

  MRoom({
    required this.id,
    required this.name,
    required this.desc,
    required this.insertedAt,
  });

  factory MRoom.fromJSON(Map<String, dynamic> json) {
    return MRoom(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      insertedAt: json['inserted_at'],
    );
  }
}
