import 'package:flutter/material.dart';

class WRooms extends StatelessWidget {
  const WRooms({Key? key}) : super(key: key);
  static const id = 'Rooms';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Fawkes | Rooms'),
        backgroundColor: Colors.red,
      ),
      body: const Text('all rooms coming soon'),
    );
  }
}
