import 'package:dynamic_island_watermark/dynamic_island_watermark.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _watermarkSelector = WatermarkSelector();

void main() {
  runApp(
    ListenableBuilder(
      listenable: _watermarkSelector,
      builder: (context, _) {
        return DynamicIslandWatermark(
          watermark: _watermarkSelector.current.widget,
          child: const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Island Watermark',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Dynamic Island Watermark'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current selected watermark:'),
            ListenableBuilder(
              listenable: _watermarkSelector,
              builder: (context, child) {
                return CupertinoButton(
                  child: Text(_watermarkSelector.current.title),
                  onPressed: () {
                    _showDialog(
                      CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: 32.0,
                        // This sets the initial item.
                        scrollController: FixedExtentScrollController(
                          initialItem: _watermarkSelector.current.index,
                        ),
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          setState(() {
                            _watermarkSelector.current =
                                Watermark.values[selectedItem];
                          });
                        },
                        children: List<Widget>.generate(
                          Watermark.values.length,
                          (int index) {
                            return Center(
                              child: Text(Watermark.values[index].title),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            // The Bottom margin is provided to align the popup above the system navigation bar.
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // Provide a background color for the popup.
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Use a SafeArea widget to avoid system overlaps.
            child: SafeArea(top: false, child: child),
          ),
    );
  }
}

class WatermarkSelector extends ChangeNotifier {
  Watermark _current = Watermark.flutterLogo;

  Watermark get current => _current;
  set current(Watermark newValue) {
    if (newValue == _current) return;
    _current = newValue;
    notifyListeners();
  }
}

enum Watermark {
  flutterLogo(widget: FlutterLogo(), title: 'Flutter Logo'),
  madeWith(widget: Center(child: Text('Made with ☕')), title: 'Made with ☕'),
  appName(widget: Center(child: Text('✨App Name✨')), title: 'App Name'),
  fakeIsland(widget: ColoredBox(color: Colors.black, child: SizedBox.expand(),), title: 'Fake Island'),
  version(widget: Center(child: Text('Version: 1.0.0')), title: 'Version stamp');

  const Watermark({required this.widget, required this.title});

  final Widget widget;
  final String title;
}
