import 'dart:async';
import 'dart:convert';

import 'package:fawkes/model/room.dart';
import 'package:fawkes/utils/endpoints.dart';
import 'package:fawkes/widgets/room.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WRooms extends StatefulWidget {
  const WRooms({Key? key}) : super(key: key);
  static const id = 'ROOMS';

  @override
  _WRoomsState createState() => _WRoomsState();
}

class _WRoomsState extends State<WRooms> {
  List<MRoom> _rooms = [];
  int? _roomId;

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  Future<void> getRooms() async {
    try {
      var res = await http.get(Uri.parse(Endpoints.rooms));
      var jsonBody = jsonDecode(res.body);
      if (jsonBody['success']) {
        var rooms =
            (jsonBody['data'] as List).map((el) => MRoom.fromJSON(el)).toList();
        setState(() {
          _rooms = rooms;
        });
      }
    } catch (e) {
      print("getRooms crashed **");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _roomId != null
        ? WRoom(roomId: _roomId!)
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text('Fawkes | Rooms'),
              backgroundColor: Colors.red,
            ),
            body: ListView.builder(
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                var room = _rooms[index];
                return ListTile(
                  title: Text(
                    room.name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _roomId = room.id;
                    });
                  },
                );
              },
            ),
          );
  }
}
