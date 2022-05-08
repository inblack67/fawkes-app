import 'package:fawkes/model/message.dart';
import 'package:flutter/material.dart';

class WMessage extends StatelessWidget {
  final MMessage message;
  const WMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 16.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                message.content,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '~ inblack67',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
