import 'dart:convert';
import 'dart:ui';

import 'package:fawkes/model/message.dart';
import 'package:fawkes/utils/endpoints.dart';
import 'package:fawkes/widgets/message.dart';
import 'package:fawkes/widgets/rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:phoenix_socket/phoenix_socket.dart';

class WRoom extends StatefulWidget {
  final int roomId;
  const WRoom({Key? key, required this.roomId}) : super(key: key);

  @override
  State<WRoom> createState() => _WRoomState();
}

class _WRoomState extends State<WRoom> {
  List<MMessage> _messages = [];
  bool _websocketConnected = false;
  PhoenixChannel? _channel;
  late FocusNode _focusNode;
  TextEditingController _messageController = TextEditingController();
  ScrollController scrollController = ScrollController(keepScrollOffset: false);
  bool _scrollToEnd = false;

  void getMessages() async {
    try {
      var res = await http
          .get(Uri.parse(Endpoints.getMessages(widget.roomId.toString())));
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

  void connectSocket() async {
    var socket = PhoenixSocket(Endpoints.websocketAPI)..connect();
    socket.openStream.listen((event) {
      print('socket connected');
      var channel = socket.addChannel(topic: 'room:${widget.roomId}');
      channel.join();
      setState(() {
        setState(() {
          _websocketConnected = true;
          _channel = channel;
        });
      });
    });

    socket.closeStream.listen((event) {
      print('channel disconnected');
      setState(() {
        _websocketConnected = false;
        _channel = null;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMessages();
    connectSocket();
    setState(() {
      _focusNode = FocusNode();
    });
  }

  void handlePostMessage() async {
    print('content ${_messageController.text}');
    if (_messageController.text.isEmpty) return;
    _channel?.push('new_message', {
      "payload": {"content": _messageController.text}
    });
    _messageController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback(((_) {
      if (_scrollToEnd) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    }));

    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        title: const Text('Fawkes | Chat'),
        backgroundColor: Colors.blueGrey[900],
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(WRooms.id);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: _channel?.messages,
                initialData: Message(
                  event: PhoenixChannelEvent.join,
                  joinRef: '',
                  payload: const {'times': 0},
                  ref: '',
                  topic: '',
                ),
                builder:
                    (BuildContext context, AsyncSnapshot<Message?> snapshot) {
                  print(snapshot.data);
                  print('sc data ${snapshot.data?.payload?['payload']}');
                  var res = snapshot.data?.payload?['payload'];
                  var newMessage = res?['message'];
                  print('new mess $newMessage');
                  if (newMessage != null) {
                    var message = MMessage.fromJSON(newMessage);
                    print('new mess $message');
                    _messages.add(message);

                    SchedulerBinding.instance?.addPostFrameCallback((_) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                    });
                  }

                  return Expanded(
                      child: ListView.builder(
                    controller: scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return WMessage(
                        message: _messages[index],
                      );
                    },
                  ));
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    autofocus: true,
                    focusNode: _focusNode,
                    controller: _messageController,
                    decoration: const InputDecoration(
                        hintText: 'Start typing...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
                Material(
                  elevation: 6.0,
                  child: MaterialButton(
                    color: Colors.blueGrey[900],
                    onPressed: handlePostMessage,
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    minWidth: 200.0,
                    height: 50.0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
