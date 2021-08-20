import 'package:flutter/material.dart';

class SuccesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Заявка добавлена"),
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: Text("Закрыть"))
      ]),
    ));
  }
}
