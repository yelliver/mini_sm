library mini_sm;

import 'package:flutter/widgets.dart';

WeakReference<Element>? _context;

class Go<T> {
  Go(this._value);

  T _value;

  final Set<WeakReference<Element>> _elementReferences = {};

  T get value {
    if (_context != null) {
      _elementReferences.add(_context!);
    }
    return _value;
  }

  set value(T value) {
    _value = value;
    go();
  }

  void go() {
    for (final elementReference in _elementReferences) {
      var element = elementReference.target;
      if (element is StatefulElement) {
        element.state.setState(() {});
      }
    }
  }

  @override
  String toString() => value.toString();
}

abstract class GoWidget extends StatefulWidget {
  const GoWidget({super.key});

  @override
  StatefulElement createElement() => _EStatefulElement(this);
}

class _EStatefulElement extends StatefulElement {
  _EStatefulElement(StatefulWidget widget) : super(widget);

  final Set<Go> values = {};

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

class GoBuilder extends GoWidget {
  const GoBuilder(this.builder, {Key? key}) : super(key: key);

  final WidgetBuilder builder;

  @override
  State<GoBuilder> createState() => _GoState();
}

class _GoState extends State<GoBuilder> {
  @override
  Widget build(BuildContext context) => widget.builder(context);
}
