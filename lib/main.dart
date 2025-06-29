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
                                  ...List.generate(m.a.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          NumberSquare(
                                            number: m.a[index].value,
                                          ),
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
                                      child: NumberSquare(
                                        number: m.b[index].value,
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
  final int number;
  const NumberSquare({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Text(number.toString()),
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
