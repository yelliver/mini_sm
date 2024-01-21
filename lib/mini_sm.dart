library mini_sm;

import 'package:flutter/widgets.dart';

class Vx<T> {
  T _value;
  final Set<VxContext> contexts = {};

  Vx(this._value);

  T call(VxContext context) {
    contexts.add(context);
    context.values.add(this);
    return _value;
  }

  T get value => _value;

  set value(T newValue) {
    if (newValue != _value) {
      _value = newValue;
      for (final context in contexts) {
        context.markNeedsBuild();
      }
    }
  }

  @override
  String toString() => _value.toString();
}

class VxWidget extends StatelessWidget {
  final Widget Function(VxContext context) builder;

  const VxWidget(this.builder, {super.key});

  @override
  VxContext createElement() => VxContext(this);

  @override
  Widget build(BuildContext context) {
    return builder(context as VxContext);
  }
}

class VxContext extends StatelessElement {
  final Set<Vx> values = {};

  VxContext(super.widget);

  @override
  void unmount() {
    for (final value in values) {
      value.contexts.remove(this);
    }
    values.clear();
    super.unmount();
  }
}
