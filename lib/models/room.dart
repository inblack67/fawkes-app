class RoomModel {
  final int id;
  final String name;
  final String desc;
  final String insertedAt;
  final String updatedAt;

  RoomModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.insertedAt,
    required this.updatedAt,
  });

  factory RoomModel.fromJSON(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      insertedAt: json['insertedAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
