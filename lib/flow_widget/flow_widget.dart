import 'package:flutter/material.dart';

const buttonSize = 80.0;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        floatingActionButton: FlowMenu(),
      ),
    );
  }
}

class FlowMenu extends StatefulWidget {
  const FlowMenu({super.key});

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildItem(IconData icon) => RawMaterialButton(
        elevation: 0,
        splashColor: Colors.black,
        fillColor: Colors.deepOrange,
        shape: const CircleBorder(),
        constraints: BoxConstraints.tight(const Size(buttonSize, buttonSize)),
        child: Icon(
          icon,
          color: Colors.white,
          size: 45,
        ),
        onPressed: () {
          if (_controller.status == AnimationStatus.completed) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(_controller),
      children: [
        Icons.menu,
        Icons.mail,
        Icons.call,
        Icons.notifications,
      ].map(buildItem).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> _controller;

  FlowMenuDelegate(this._controller) : super(repaint: _controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;

    for (var i = context.childCount - 1; i >= 0; i--) {
      const margin = 8;
      final width = context.getChildSize(i)?.width;
      if (width == null) {
        throw NullThrownError();
      }
      final dx = (width + margin) * i;
      final x = xStart;
      final y = yStart - dx * _controller.value;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return _controller != oldDelegate._controller;
  }
}
