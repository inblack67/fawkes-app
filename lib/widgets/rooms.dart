import 'dart:async';
import 'dart:convert';

import 'package:fawkes/model/room.dart';
import 'package:fawkes/utils/endpoints.dart';
import 'package:fawkes/widgets/chat.dart';
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
  MRoom? _room;

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Fawkes | Rooms'),
        backgroundColor: Colors.red,
      ),
      body: _room != null
          ? WChat(roomId: _room!.id)
          : ListView.builder(
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
                    print('${room.name} tapped');
                    setState(() {
                      _room = room;
                    });
                  },
                );
              },
            ),
    );
  }
}
