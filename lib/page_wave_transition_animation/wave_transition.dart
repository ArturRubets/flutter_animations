import 'package:flutter/material.dart';

class WaveTransition extends StatelessWidget {
  const WaveTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _PageOne(),
    );
  }
}

class _PageOne extends StatelessWidget {
  const _PageOne();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ColoredBox(
        color: Colors.blueGrey,
        child: Center(
          child: Text('Page 1'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder<void>(
              pageBuilder: (_, __, ___) {
                return const _PageTwo();
              },
              opaque: false,
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class _PageTwo extends StatelessWidget {
  const _PageTwo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 15000),
        child: const ColoredBox(
          color: Colors.lightGreen,
          child: Center(
            child: Text('Page 2'),
          ),
        ),
        builder: (context, value, child) {
          return ShaderMask(
            shaderCallback: (rect) {
              return RadialGradient(
                radius: value * 5,
                colors: const [
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: const [0, 0.55, 0.6, 1],
                center: const Alignment(0.95, 0.9),
              ).createShader(rect);
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
