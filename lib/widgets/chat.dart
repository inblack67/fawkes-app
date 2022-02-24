import 'package:fawkes/utils/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_socket/phoenix_socket.dart';

class WChat extends StatefulWidget {
  final int roomId;
  const WChat({Key? key, required this.roomId}) : super(key: key);

  @override
  _WChatState createState() => _WChatState();
}

class _WChatState extends State<WChat> {
  bool _websocketsConnected = false;

  @override
  void initState() {
    super.initState();
    joinChannel();
  }

  void joinChannel() {
    var socket = PhoenixSocket(Endpoints.websocket)..connect();
    socket.openStream.listen((event) {
      var channel = socket.addChannel(topic: 'room:${widget.roomId}');
      channel.join();
      setState(() {
        _websocketsConnected = true;
      });
      print(
          'websocket connected and channel with roomId:${widget.roomId} joined');
    });
    socket.closeStream.listen((event) {
      print('socket disconnected...');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
