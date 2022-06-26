library mini_sm;

import 'package:flutter/widgets.dart';

Set<Value>? _context;

class Value<T> {
  Value(this._value);

  T _value;

  final Set<State> _states = {};

  T get value {
    _context?.add(this);
    return _value;
  }

  set value(T value) {
    _value = value;
    update();
  }

  void update() => _states.forEach(_setState);

  void _setState(State state) => state.setState(() {});

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
      _context = values;
      _context?.forEach(unregister);
      _context?.clear();
      return super.build();
    } finally {
      _context?.forEach(register);
      _context = null;
    }
  }

  @override
  void unmount() {
    values.forEach(unregister);
    super.unmount();
  }

  void register(Value value) => value._states.add(state);

  void unregister(Value value) => value._states.remove(state);
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
