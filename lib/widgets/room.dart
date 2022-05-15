import 'dart:convert';

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
  PhoenixChannel? _channel;
  final TextEditingController _messageController = TextEditingController();
  late FocusNode _focusNode;
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
          _scrollToEnd = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void joinRoom() {
    var socket = PhoenixSocket(Endpoints.websocket)..connect();
    socket.openStream.listen((event) {
      print('socket connected');
      var channel = socket.addChannel(topic: 'room:${widget.roomId}');
      channel.join();
      setState(() {
        _channel = channel;
      });
    });
    socket.closeStream.listen((event) {
      print('socket disconnected');
    });
  }

  void postMessage() {
    print('text=>');
    print(_messageController.text);
    if (_messageController.text.isEmpty) return;
    _channel?.push('new_message', {
      "payload": {"content": _messageController.text}
    });
    _focusNode.requestFocus();
    _messageController.clear();
  }

  @override
  void initState() {
    super.initState();
    joinRoom();
    getMessages();
    setState(() {
      _focusNode = FocusNode();
    });
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
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
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
                    print('snap ${snapshot.data}');
                    var newMessage =
                        snapshot.data?.payload?['payload']?['message'];
                    print('new message $newMessage');
                    if (newMessage != null) {
                      _messages.add(MMessage.fromJSON(newMessage));
                      SchedulerBinding.instance?.addPostFrameCallback((_) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      });
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return WMessage(
                          message: _messages[index],
                        );
                      },
                    );
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: _messageController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                      hintText: 'Start typing...',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      )),
                )),
                Material(
                  child: MaterialButton(
                    onPressed: postMessage,
                    minWidth: 200,
                    elevation: 6.0,
                    color: Colors.blueGrey[900],
                    child: const Text(
                      'Send',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
