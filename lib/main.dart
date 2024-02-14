import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'database.dart';

/// Flutter code sample for [ReorderableListView].

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');

  runApp(MaterialApp(
    home: ReorderableApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class ReorderableApp extends StatelessWidget {
  const ReorderableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ReorderableListView Sample')),
        body: const ReorderableExample(),
      ),
    );
  }
}

class ReorderableExample extends StatefulWidget {
  const ReorderableExample({super.key});

  @override
  State<ReorderableExample> createState() => _ReorderableListViewExampleState();
}

class _ReorderableListViewExampleState extends State<ReorderableExample> {
  Database obj = Database();
  final box = Hive.box('mybox');

  @override
  void initState() {
    // TODO: implement itState
    if (box.isNotEmpty) {
      obj.load();
    } else {
      obj.tasks = [
        ["a", 0],
        ["b", 1],
        ["c", 2],
        ["d", 3]
      ];
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      children: <Widget>[
        for (int index = 0; index < obj.tasks.length; index++)
          ListTile(
            key: Key('$index'),
            tileColor: index.isOdd ? oddItemColor : evenItemColor,
            title: Text('item name = ${obj.tasks[index][1]}${obj.tasks[index][0]}'),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = obj.tasks.removeAt(oldIndex);
          obj.tasks.insert(newIndex, item);
          obj.save();
        });
      },
    );
  }
}
