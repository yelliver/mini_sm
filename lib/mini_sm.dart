library mini_sm;

import 'dart:collection';

import 'package:flutter/widgets.dart';

WeakReference<Element>? _context;

class Value<T> {
  Value(this._value);

  T _value;

  final _listeners = HashSet<WeakReference<Element>>();

  T get value {
    if (_context != null) {
      _listeners.add(_context!);
    }
    return _value;
  }

  set value(T value) {
    _value = value;
    update();
  }

  void update() {
    for (final listener in _listeners) {
      var element = listener.target;
      if (element is StatefulElement) {
        element.state.setState(() {});
      }
    }
  }

  @override
  String toString() => value.toString();
}

abstract class MeWidget extends StatefulWidget {
  const MeWidget({super.key});

  @override
  StatefulElement createElement() => _EStatefulElement(this);
}

class _EStatefulElement extends StatefulElement {
  _EStatefulElement(StatefulWidget widget) : super(widget);

  final Set<Value> values = {};

  @override
  Widget build() {
    try {
      _context = WeakReference(this);
      return super.build();
    } finally {
      _context = null;
    }
  }
}

class MiWidget extends MeWidget {
  const MiWidget(this.builder, {Key? key}) : super(key: key);

  final WidgetBuilder builder;

  @override
  State<MiWidget> createState() => _IWidgetState();
}

class _IWidgetState extends State<MiWidget> {
  @override
  Widget build(BuildContext context) => widget.builder(context);
}
