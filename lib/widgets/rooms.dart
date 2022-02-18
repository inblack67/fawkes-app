import 'dart:async';
import 'dart:convert';

import 'package:fawkes/models/room.dart';
import 'package:fawkes/utils/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WRooms extends StatefulWidget {
  static const id = 'ROOMS';
  const WRooms({Key? key}) : super(key: key);

  @override
  _WRoomsState createState() => _WRoomsState();
}

class _WRoomsState extends State<WRooms> {
  List<Room> _rooms = [];

  @override
  void initState() {
    getRooms();
  }

  Future<void> getRooms() async {
    try {
      var res = await http.get(Uri.parse(Endpoints.rooms));
      var resData = jsonDecode(res.body);
      print(resData);
      if (resData['success']) {
        var rooms =
            (resData['data'] as List).map((el) => Room.fromJSON(el)).toList();
        print('rooms**');
        print(rooms);
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
              print('${room.name} room tapped');
            },
          );
        },
      ),
    );
  }
}
