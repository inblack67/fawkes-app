import 'dart:async';
import 'dart:convert';

import 'package:fawkes/utils/APIURLs.dart';
import 'package:flutter/material.dart';
import 'package:fawkes/models/room.dart';
import 'package:http/http.dart' as http;

class WRooms extends StatefulWidget {
  const WRooms({Key? key}) : super(key: key);
  static const id = 'ROOMS';

  @override
  WRoomsState createState() => WRoomsState();
}

class WRoomsState extends State<WRooms> {
  late List<RoomModel> _rooms;

  @override
  void initState() {
    getRooms();
  }

  void getRooms() async {
    try {
      print(APIUrls.getRooms);
      var res = await http.get(Uri.parse(APIUrls.getRooms));
      var jsonBody = jsonDecode(res.body);
      print(jsonBody);
      setState(() {
        _rooms = [];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Fawkes'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
