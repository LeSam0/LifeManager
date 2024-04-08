import 'package:flutter/material.dart';

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffre fort'),
      ),
      body: Center(
        child: const Text('This is Page 5'),
      ),
    );
  }
}
