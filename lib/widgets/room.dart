import 'dart:convert';

import 'package:fawkes/model/message.dart';
import 'package:fawkes/utils/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WRoom extends StatefulWidget {
  final int roomId;
  const WRoom({Key? key, required this.roomId}) : super(key: key);

  @override
  State<WRoom> createState() => _WRoomState();
}

class _WRoomState extends State<WRoom> {
  List<MMessage> _messages = [];

  void getMessages() async {
    try {
      var res = await http.get(Uri.parse(Endpoints.getMessages(widget.roomId.toString())));
      var jsonBody = jsonDecode(res.body);
      if (jsonBody["success"] == true) {
        setState(() {
          _messages = (jsonBody["data"] as List)
              .map((e) => MMessage.fromJSON(e))
              .toList();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Fawkes | Chat'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          var message = _messages[index];
          return ListTile(
            title: Text(
              message.content,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
