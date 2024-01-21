import 'package:example/order_app.dart';
import 'package:example/random_number_app.dart';
import 'package:flutter/material.dart';

import 'counter_app.dart';

void main() {
  runApp(MyApp());
}

class Example {
  final String title;
  final String desc;
  final Widget Function() widget;

  Example({
    required this.title,
    required this.desc,
    required this.widget,
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Example> examples = [
    Example(
      title: 'Counter',
      desc: 'Traditional counter example',
      widget: () => const CounterApp(),
    ),
    Example(
      title: 'Random Number',
      desc: 'Random Number example',
      widget: () => const RandomNumberApp(),
    ),
    Example(
      title: 'Order',
      desc: 'Food Order example',
      widget: () => const OrderApp(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Examples'),
          ),
          body: ListView.builder(
            itemCount: examples.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(examples[index].title),
                subtitle: Text(examples[index].desc),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => examples[index].widget(),
                    ),
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
