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
        content: TextField(controller: m.controller, maxLines: 2),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              m.inputSorted(context);
              m.inputSwap(context);
              Navigator.of(context).pop();
            },
            child: const Text("Add Info"),
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
              title: Text("Level ${m.level}"),
              actions: [
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
                    label: Icon(Icons.copy_all),
                    onPressed: () {
                      m.copyStartValues(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ActionChip(
                    label: Icon(Icons.bug_report),
                    onPressed: () {
                      m.callBridge(context);
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
                                  if (m.a.length > 1)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            m.apply("ra");
                                          },
                                          child: Text("ra↑"),
                                        ),
                                        if (m.a.length > 1 && m.b.length > 1)
                                          ElevatedButton(
                                            onPressed: () {
                                              m.apply("rr");
                                            },
                                            child: Text("rr↑"),
                                          ),
                                      ],
                                    ),
                                  ...List.generate(m.a.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (index == 0)
                                            ElevatedButton(
                                              onPressed: () {
                                                m.apply("sa");
                                              },
                                              child: Text("sa↕"),
                                            ),
                                          NumberSquare(node: m.a[index]),
                                          if (index == 0)
                                            ElevatedButton(
                                              onPressed: () {
                                                m.apply("pb");
                                              },
                                              child: Text("pb→"),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                                  if (m.a.length > 1)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            m.apply("rra");
                                          },
                                          child: Text("rra↓"),
                                        ),
                                        if (m.a.length > 1 && m.b.length > 1)
                                          ElevatedButton(
                                            onPressed: () {
                                              m.apply("rrr");
                                            },
                                            child: Text("rrr↓"),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Title(text: "Col B"),
                                  if (m.b.length > 1)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            m.apply("rb");
                                          },
                                          child: Text("rb↑"),
                                        ),
                                        if (m.a.length > 1 && m.b.length > 1)
                                          ElevatedButton(
                                            onPressed: () {
                                              m.apply("rr");
                                            },
                                            child: Text("rr↑"),
                                          ),
                                      ],
                                    ),
                                  ...List.generate(m.b.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (index == 0)
                                            ElevatedButton(
                                              onPressed: () {
                                                m.apply("pa");
                                              },
                                              child: Text("←pa"),
                                            ),
                                          NumberSquare(node: m.b[index]),
                                          if (index == 0)
                                            ElevatedButton(
                                              onPressed: () {
                                                m.apply("sb");
                                              },
                                              child: Text("sb↕"),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                                  if (m.b.length > 1)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            m.apply("rrb");
                                          },
                                          child: Text("rrb↓"),
                                        ),
                                        if (m.a.length > 1 && m.b.length > 1)
                                          ElevatedButton(
                                            onPressed: () {
                                              m.apply("rrr");
                                            },
                                            child: Text("rrr↓"),
                                          ),
                                      ],
                                    ),
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
    return Stack(
      children: [
        FloatingActionButton(
          backgroundColor: (node.isSorted) ? Colors.lightGreen : null,
          onPressed: () {},
          child: Text(node.value.toString()),
        ),
        if (node.needSwap) Icon(Icons.swap_vert, color: Colors.red),
      ],
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
