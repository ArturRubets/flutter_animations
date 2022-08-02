import 'package:flutter/material.dart';

class MusicVisualizer extends StatelessWidget {
  const MusicVisualizer({super.key});

  static const colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.yellowAccent,
  ];
  static const duration = [900, 700, 600, 800, 500];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              10,
              (index) => VisualComponent(
                duration: duration[index % duration.length],
                color: colors[index % colors.length],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VisualComponent extends StatefulWidget {
  const VisualComponent({
    super.key,
    required this.duration,
    required this.color,
  });

  final int duration;
  final Color color;

  @override
  State<VisualComponent> createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Container(
        width: 10,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(5),
        ),
        height: _animation.value,
      ),
    );
  }
}
