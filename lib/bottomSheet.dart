import 'package:flutter/material.dart';
import 'package:flutter_assignment_1/model.dart';

class BottomSheetWidget extends StatelessWidget {
  final Comments comment;

  const BottomSheetWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: description(comment),
    );
  }

  Widget description(Comments obj) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${obj.name}'),
          Text('Email: ${obj.email}'),
          Text('Body: ${obj.body.trim()}'),
        ],
      ),
    );
  }
}
