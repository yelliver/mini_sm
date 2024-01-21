import 'package:flutter/material.dart';
import 'package:mini_sm/mini_sm.dart';

class DataModel {
  final counter = Vx(0);

  void incrementCounter() {
    counter.value++;
  }
}

final model = DataModel();

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            VxWidget((context) => Text('${model.counter(context)}', style: Theme.of(context).textTheme.headlineMedium)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: model.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
