import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_swap_it/const.dart';
import 'package:push_swap_it/model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => Model(), child: MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void inputText(BuildContext context, Model m) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Input Values"),
        content: TextField(controller: m.controller),
        actions: [
          TextButton(
            onPressed: () {
              m.inputSorted(context);
              Navigator.of(context).pop();
            },
            child: const Text("Sorted"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              m.inputText(context);
              Navigator.of(context).pop();
            },
            child: const Text("Input"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<Model>(
        builder: (context, m, child) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ActionChip(
                    label: Icon(Icons.copy_all),
                    onPressed: () {
                      m.copyStartValues(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ActionChip(
                    label: Icon(Icons.refresh),
                    onPressed: m.revert,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ActionChip(
                    label: Icon(Icons.shuffle),
                    onPressed: m.refresh,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ActionChip(
                    label: Icon(Icons.input),
                    onPressed: () {
                      inputText(context, m);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ActionChip(
                    label: Icon(Icons.remove),
                    onPressed: m.levelDown,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ActionChip(
                    label: Icon(Icons.add),
                    onPressed: m.levelUp,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(3.0),
                //   child: FilterChip(
                //     label: const Text("Debug"),
                //     selected: m.debug,
                //     onSelected: m.chageDebug,
                //   ),
                // ),
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Title(text: "Col A"),
                                  ...List.generate(m.a.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          NumberSquare(node: m.a[index]),
                                          if (m.debug)
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Text(
                                                "${m.a[index].order}-${m.a[index].position} : ${m.a[index].order - m.a[index].position}",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Title(text: "Col B"),
                                  ...List.generate(m.b.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: NumberSquare(node: m.b[index]),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...List.generate(commands.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: ActionChip(
                                        onPressed: () {
                                          m.apply(commands[index]);
                                        },
                                        label: Text(
                                          commands[index],
                                          style: buttonText,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Movements: ${m.commands.length}${(m.best != 0) ? " | Best: ${m.best}" : ""}",
                      style: buttonText,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (m.debug)
                              ...List.generate(m.commands.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(m.commands[index]),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (m.solved)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "SOLVED",
                      style: TextStyle(fontSize: 80, color: Colors.green),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NumberSquare extends StatelessWidget {
  final Node node;
  const NumberSquare({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: (node.isSorted) ? Colors.lightGreen : null,
      onPressed: () {},
      child: Text(node.value.toString()),
    );
  }
}

class Title extends StatelessWidget {
  final String text;
  const Title({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
