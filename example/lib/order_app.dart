import 'dart:math';

import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mini_sm/mini_sm.dart';

final faker = Faker();
final random = Random();

class MyItem {
  MyItem(this.name, this.price);

  Vx<bool> check = Vx(false);
  String name;
  int price;
  Vx<int> quantity = Vx(1);

  String quantityTxt(VxContext context) => quantity(context).toString().padLeft(2, '0');
}

class MyController {
  final myItems = Vx(<MyItem>[]);
  final showTotal = Vx(true);

  Iterable<Vx> quantityFields(VxContext context) => myItems(context).map((e) => e.quantity);

  bool? allChecked(VxContext context) {
    var num = myItems(context).map((item) => item.check(context) ? 1 : 0).sum;
    if (num == 0) return false;
    if (num == myItems(context).length) return true;
    return null;
  }

  bool anyChecked(VxContext context) => myItems(context).any((item) => item.check(context));

  int totalPrice(VxContext context) {
    return myItems(context).map((item) => item.quantity(context) * item.price).sum;
  }

  void addItem() {
    myItems.value = List<MyItem>.from(myItems.value)..add(MyItem(faker.food.dish(), random.nextInt(100)));
  }

  void removeItem() {
    myItems.value = myItems.value.where((item) => !item.check.value).toList();
  }

  void clickMasterCheckbox(bool? value) {
    for (var checkbox in myItems.value) {
      checkbox.check.value = value ?? false;
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
                VxWidget(
                  (context) => Checkbox(
                    tristate: true,
                    value: ctrl.allChecked(context),
                    onChanged: ctrl.myItems.value.isNotEmpty ? ctrl.clickMasterCheckbox : null,
                  ),
                ),
                ElevatedButton(
                  onPressed: ctrl.addItem,
                  child: const Text('Add'),
                ),
                Container(padding: const EdgeInsets.all(5)),
                VxWidget(
                  (context) => ElevatedButton(
                    onPressed: ctrl.anyChecked(context) ? ctrl.removeItem : null,
                    child: const Text('Remove'),
                  ),
                ),
                const Spacer(),
                VxWidget((context) {
                  if (ctrl.showTotal(context)) {
                    return Text(
                      'Total: \$${ctrl.totalPrice(context)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  } else {
                    return const Spacer();
                  }
                }),
                VxWidget(
                  (context) => Checkbox(
                    tristate: true,
                    value: ctrl.showTotal(context),
                    onChanged: ctrl.clickShowTotal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: VxWidget(
              (context) => ListView.builder(
                itemCount: ctrl.myItems(context).length,
                itemBuilder: (context, index) {
                  var item = ctrl.myItems.value[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price}'),
                      leading: VxWidget((context) {
                        return Checkbox(
                          value: item.check(context),
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
                          VxWidget((context) => Text(item.quantityTxt(context))),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
