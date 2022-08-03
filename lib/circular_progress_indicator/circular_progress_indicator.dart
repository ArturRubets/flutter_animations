import 'package:flutter/material.dart';

class CircularProgressIndicatorPage extends StatelessWidget {
  const CircularProgressIndicatorPage({super.key});

  static const size = 200.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Progress indicator'),
        ),
        body: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 4),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (_, value, __) {
              final percentage = (value * 100).ceil();

              return SizedBox(
                height: size,
                width: size,
                child: Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return SweepGradient(
                          stops: [value, value],
                          colors: [Colors.blue, Colors.grey.withAlpha(55)],
                        ).createShader(bounds);
                      },
                      // ignore: use_decorated_box
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: size - 40,
                        height: size - 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$percentage',
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
