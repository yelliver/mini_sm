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
      final element = elementReference.target;
      if (element != null && element.mounted) {
        element.markNeedsBuild();
      }
    }
    _elementReferences.clear();
  }
}

extension IterableGo on Iterable<Go> {
  void go(VoidCallback fn) => forEach((value) => value.go(() {}));
}

class GoBuilder extends StatelessWidget {
  const GoBuilder(this.builder, {super.key});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    var oldContext = _context;
    _context = WeakReference(context as Element);
    try {
      return builder(context);
    } finally {
      _context = oldContext;
    }
  }
}
