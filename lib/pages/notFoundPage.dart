import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Книга по данному ISBN не найдена"),
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: Text("Закрыть"))
      ]),
    ));
  }
}
