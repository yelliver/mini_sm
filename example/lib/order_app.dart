import 'dart:math';

import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mini_sm/mini_sm.dart';

final faker = Faker();
final random = Random();

class MyItem {
  MyItem(this.name, this.price);

  Value<bool> check = Value(false);
  String name;
  int price;
  Value<int> quantity = Value(1);

  String get quantityTxt => quantity.toString().padLeft(2, '0');
}

class MyController {
  final myItems = Value(<MyItem>[]);
  final showTotal = Value(true);

  Iterable<Value> get checkFields => myItems.value.map((e) => e.check);

  Iterable<Value> get quantityFields => myItems.value.map((e) => e.quantity);

  bool? get allChecked {
    var num = myItems.value.map((item) => item.check.value ? 1 : 0).sum;
    if (num == 0) return false;
    if (num == myItems.value.length) return true;
    return null;
  }

  bool get anyChecked => myItems.value.any((item) => item.check.value);

  int get totalPrice {
    return myItems.value.map((item) => item.quantity.value * item.price).sum;
  }

  void addItem() {
    myItems.value.add(MyItem(faker.food.dish(), random.nextInt(100)));
    myItems.update();
  }

  void removeItem() {
    myItems.value.removeWhere((item) => item.check.value);
    myItems.update();
  }

  void clickMasterCheckbox(bool? value) {
    for (var checkbox in checkFields) {
      checkbox.value = value ?? false;
    }
  }

  void clickShowTotal(bool? value) {
    showTotal.value = value ?? false;
  }

  void clickCheckbox(MyItem item) {
    item.check.value ^= true;
  }

  void dcrQuantity(MyItem item) {
    if (item.quantity.value > 0) {
      item.quantity.value--;
    }
  }

  void incQuantity(MyItem item) {
    if (item.quantity.value < 10) {
      item.quantity.value++;
    }
  }
}

var ctrl = MyController();

class OrderApp extends StatelessWidget {
  const OrderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MiWidget((context) {
                    return Checkbox(
                      tristate: true,
                      value: ctrl.allChecked,
                      onChanged: ctrl.checkFields.isNotEmpty
                          ? ctrl.clickMasterCheckbox
                          : null,
                    );
                  }),
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: ctrl.addItem,
                  ),
                  Container(padding: const EdgeInsets.all(5)),
                  MiWidget((context) {
                    return ElevatedButton(
                      child: const Text('Remove'),
                      onPressed: ctrl.anyChecked ? ctrl.removeItem : null,
                    );
                  }),
                  const Spacer(),
                  MiWidget((context) {
                    if (ctrl.showTotal.value) {
                      return Text(
                        'Total: \$${ctrl.totalPrice}',
                        style: Theme.of(context).textTheme.headline6,
                      );
                    } else {
                      return const Spacer();
                    }
                  }),
                  MiWidget((context) {
                    return Checkbox(
                      tristate: true,
                      value: ctrl.showTotal.value,
                      onChanged: ctrl.clickShowTotal,
                    );
                  }),
                ]),
          ),
          Expanded(
            child: MiWidget((context) {
              return ListView.builder(
                itemCount: ctrl.myItems.value.length,
                itemBuilder: (context, index) {
                  var item = ctrl.myItems.value[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price}'),
                      leading: MiWidget((context) {
                        return Checkbox(
                          value: item.check.value,
                          onChanged: (bool? value) => ctrl.clickCheckbox(item),
                        );
                      }),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            splashRadius: 15,
                            onPressed: () => ctrl.dcrQuantity(item),
                          ),
                          MiWidget((context) => Text(item.quantityTxt)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            splashRadius: 15,
                            onPressed: () => ctrl.incQuantity(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
