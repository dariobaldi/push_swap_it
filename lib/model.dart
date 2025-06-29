import 'dart:math';

import 'package:flutter/material.dart';
import 'package:push_swap_it/sort.dart';

class Node {
  final int value;
  final int position;
  int order;

  Node({required this.value, required this.position, required this.order});
}

class Model extends ChangeNotifier {
  List<Node> _a = generateUniqueRandomInts(count: 5, min: 0, max: 5);
  List<Node> _b = [];
  List<Node> _original = [];
  List<String> _commands = [];
  bool _solved = false;
  bool _debug = false;
  int _best = 0;
  int _level = 5;
  final TextEditingController _controller = TextEditingController();

  Model();

  List<String> get commands => _commands;
  List<Node> get a => _a;
  List<Node> get b => _b;
  bool get solved => _solved;
  bool get debug => _debug;
  int get best => _best;
  int get level => _level;
  TextEditingController get controller => _controller;

  void chageDebug(bool value) {
    _debug = value;
    notifyListeners();
  }

  void levelUp() {
    _level++;
    refresh();
  }

  void levelDown() {
    if (_level <= 3) return;
    _level--;
    refresh();
  }

  void apply(String command) {
    if (_original.isEmpty) {
      for (var node in _a) {
        _original.add(node);
      }
    }
    switch (command) {
      case "sa":
        sa();
      case "sb":
        sb();
      case "ss":
        ss();
      case "pa":
        pa();
      case "pb":
        pb();
      case "ra":
        ra();
      case "rb":
        rb();
      case "rr":
        rr();
      case "rra":
        rra();
      case "rrb":
        rrb();
      case "rrr":
        rrr();
      default:
        _commands.add("[error: $command not implemented]");
    }
    checkSolved();
    notifyListeners();
  }

  void sa() {
    if (_a.length < 2) {
      return;
    }
    _commands.add("sa");
    final buf = _a[0];
    _a[0] = _a[1];
    _a[1] = buf;
  }

  void sb() {
    if (_b.length < 2) {
      return;
    }
    _commands.add("sb");
    final buf = _b[0];
    _b[0] = _b[1];
    _b[1] = buf;
  }

  void ss() {
    if (_b.length < 2 || _a.length < 2) {
      return;
    }
    _commands.add("ss");
    var buf = _b[0];
    _b[0] = _b[1];
    _b[1] = buf;
    buf = _a[0];
    _a[0] = _a[1];
    _a[1] = buf;
  }

  void pb() {
    if (_a.isEmpty) {
      return;
    }
    _commands.add("pb");
    _b.insert(0, _a[0]);
    _a.removeAt(0);
  }

  void pa() {
    if (_b.isEmpty) {
      return;
    }
    _commands.add("pa");
    _a.insert(0, _b[0]);
    _b.removeAt(0);
  }

  void ra() {
    if (_a.length < 2) {
      return;
    }
    _commands.add("ra");
    _a.add(_a[0]);
    _a.removeAt(0);
  }

  void rb() {
    if (_b.length < 2) {
      return;
    }
    _commands.add("rb");
    _b.add(_b[0]);
    _b.removeAt(0);
  }

  void rr() {
    if (_a.length < 2 || _b.length < 2) {
      return;
    }
    _commands.add("rr");
    _a.add(_a[0]);
    _a.removeAt(0);
    _b.add(_b[0]);
    _b.removeAt(0);
  }

  void rra() {
    if (_a.length < 2) {
      return;
    }
    _commands.add("rra");
    _a.insert(0, _a.last);
    _a.removeLast();
  }

  void rrb() {
    if (_b.length < 2) {
      return;
    }
    _commands.add("rrb");
    _b.insert(0, _b.last);
    _b.removeLast();
  }

  void rrr() {
    if (_a.length < 2 || _b.length < 2) {
      return;
    }
    _commands.add("rr");
    _a.insert(0, _a.last);
    _a.removeLast();
    _b.insert(0, _b.last);
    _b.removeLast();
  }

  void refresh() {
    _a = generateUniqueRandomInts(count: _level, min: 0, max: _level);
    _b = [];
    _commands = [];
    _original = [];
    for (var node in _a) {
      _original.add(node);
    }
    _solved = false;
    _best = 0;
    notifyListeners();
  }

  void revert() {
    if (_original.isEmpty) {
      return;
    }
    _a = [];
    _b = [];
    _commands = [];
    _solved = false;
    for (var node in _original) {
      _a.add(node);
    }
    notifyListeners();
  }

  void checkSolved() {
    if (_b.isNotEmpty) {
      return;
    }
    for (var i = 0; i < _a.length - 1; i++) {
      if (_a[i].value > _a[i + 1].value) {
        return;
      }
    }
    _solved = true;
    if (_best == 0 || _best > _commands.length) {
      _best = _commands.length;
    }
  }

  void inputText(BuildContext context) {
    _solved = false;
    try {
      final numbers = _controller.text
          .trim()
          .split(RegExp(r'\s+'))
          .toSet()
          .map(int.parse)
          .toList();
      _a = [];
      _b = [];
      _commands = [];
      _original = [];
      for (var i = 0; i < numbers.length; i++) {
        _a.add(Node(value: numbers[i], position: i, order: i));
        _original.add(_a.last);
      }
      checkSolved();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  "Invalid input: $e",
                  maxLines: 10,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
    notifyListeners();
  }
}

List<Node> generateUniqueRandomInts({
  required int count,
  required int min,
  required int max,
}) {
  if (max - min + 1 < count) {
    throw ArgumentError('Range is too small for $count unique values');
  }

  final rand = Random();
  final set = <int>{};

  while (set.length < count) {
    set.add(rand.nextInt(max - min + 1) + min);
  }

  List<int> numbers = set.toList();
  List<Node> list = [];
  for (var i = 0; i < numbers.length; i++) {
    list.add(Node(value: numbers[i], position: i, order: i));
  }
  sortList(list);
  return list;
}
