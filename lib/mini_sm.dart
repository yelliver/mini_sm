library mini_sm;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

WeakReference<Element>? _context;

class Go<T> {
  Go(this._value);

  T _value;

  final Set<WeakReference<Element>> _elementReferences = {};

  T get peek => _value;

  T get value {
    assert(SchedulerBinding.instance.schedulerPhase != SchedulerPhase.persistentCallbacks || _context != null,
        'Do read `${this.runtimeType}` in a GoBuilder to provide the context during the `build` pipeline.');
    var localContext = _context;
    if (localContext != null) {
      _elementReferences.add(localContext);
    }
    return _value;
  }

  set value(T newValue) {
    assert(SchedulerBinding.instance.schedulerPhase != SchedulerPhase.persistentCallbacks,
        'Do not write `${this.runtimeType}` during the `build` pipeline.');
    if (_value != newValue) {
      _value = newValue;
      go(() {});
    }
  }

  void go(VoidCallback fn) {
    fn();
    for (final elementReference in _elementReferences) {
      var element = elementReference.target;
      if (element is StatefulElement) {
        element.state.setState(() {});
      }
    }
  }
}

extension IterableGo on Iterable<Go> {
  void go(VoidCallback fn) => forEach((value) => value.go(() {}));
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
