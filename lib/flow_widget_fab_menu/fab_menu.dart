import 'dart:math' as math;

import 'package:flutter/material.dart';

const buttonSize = 80.0;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        floatingActionButton: FlowFabMenu(),
      ),
    );
  }
}

class FlowFabMenu extends StatefulWidget {
  const FlowFabMenu({super.key});

  @override
  State<FlowFabMenu> createState() => _FlowFabMenuState();
}

class _FlowFabMenuState extends State<FlowFabMenu>
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
        Icons.mail,
        Icons.call,
        Icons.notifications,
        Icons.accessibility,
        Icons.menu,
      ].map(buildItem).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate(this._controller) : super(repaint: _controller);

  final Animation<double> _controller;

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;

    for (var i = 0; i < context.childCount; i++) {
      final isLastItem = i == context.childCount - 1;

      final radius = _controller.value * 180;

      /// 2 из 5 кнопок не нужно считать угол. Первой и последней кнопке,
      /// у первой кнопки угол ноль радиан, а последняя стоит на месте
      /// потому что это кнопка меню.
      final angle = i * (math.pi * 0.5) / (context.childCount - 2);

      final x = xStart - (isLastItem ? 0 : radius * math.cos(angle));
      final y = yStart - (isLastItem ? 0 : radius * math.sin(angle));
      context.paintChild(
        i,
        transform: Matrix4.identity()
          ..translate(x, y)
          ..translate(buttonSize / 2, buttonSize / 2)
          ..rotateZ(isLastItem ? 0.0 : 180 * (1 - _controller.value))
          ..scale(isLastItem ? 1.0 : math.max(_controller.value, 0.5))
          ..translate(-buttonSize / 2, -buttonSize / 2),
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return _controller != oldDelegate._controller;
  }
}
