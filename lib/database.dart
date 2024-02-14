// database.dart
import 'package:hive/hive.dart';

class Database {
  List tasks = [];

  final box = Hive.box('mybox');

  void load() {
    tasks = box.get('list');

  }

  void save() {
    box.put('list', tasks);


  }
}
