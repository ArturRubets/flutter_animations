import 'package:flutter/material.dart';

class MusicVisualizer extends StatelessWidget {
  static const colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.yellowAccent,
  ];
  static const duration = [900, 700, 600, 800, 500];

  const MusicVisualizer({super.key});

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
              (index) => _VisualComponent(
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

class _VisualComponent extends StatefulWidget {
  final int duration;
  final Color color;

  const _VisualComponent({
    required this.duration,
    required this.color,
  });

  @override
  State<_VisualComponent> createState() => _VisualComponentState();
}

class _VisualComponentState extends State<_VisualComponent>
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
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        height: _animation.value,
      ),
    );
  }
}
