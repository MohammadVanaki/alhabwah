import 'package:flutter/material.dart';

class InternalPage extends StatelessWidget {
  const InternalPage({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Container(margin: EdgeInsets.only(top: 0), child: child)],
      ),
    );
  }
}
