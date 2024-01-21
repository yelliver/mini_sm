import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mini_sm/mini_sm.dart';

class DataModel {
  final randomNumber = Vx(Random().nextInt(9999));

  void generate() {
    randomNumber.value = Random().nextInt(9999);
  }
}

final model = DataModel();

class RandomNumberApp extends StatelessWidget {
  const RandomNumberApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Random number'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VxWidget((context) => Text(model.randomNumber(context).toString())),
            ElevatedButton(
              onPressed: model.generate,
              child: const Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
