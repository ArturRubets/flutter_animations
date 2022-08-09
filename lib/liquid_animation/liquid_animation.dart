import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

import 'constants.dart';

class LiquidAnimation extends StatelessWidget {
  const LiquidAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _MyHomePage(title: 'Flutter Canvas Animation'),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({ required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      upperBound: 360,
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    );
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: ColoredBox(
        color: const Color(0xFF68122C),
        child: AnimatedBuilder(
          animation: animationController,
          builder: (_, __) => Stack(
            children: [
              Positioned(
                top: size.height / 2,
                left: size.width / 2,
                child: ClipPath(
                  clipper: _CircleClipper(),
                  child: CustomPaint(
                    size: kSize,
                    painter: _WavePainter(
                      animationController: animationController,
                      isRightDirection: true,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height / 2,
                left: size.width / 2,
                child: ClipPath(
                  clipper: _CircleClipper(),
                  child: CustomPaint(
                    size: kSize,
                    painter: _WavePainter(
                      animationController: animationController,
                      isRightDirection: false,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height / 2,
                left: size.width / 2,
                child: CustomPaint(
                  size: kSize,
                  painter: _FlaskPainter(),
                ),
              ),
              Positioned(
                top: size.height / 2,
                left: size.width / 2,
                child: CustomPaint(
                  size: kSize,
                  painter: _ReflectionPainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReflectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      -size.width / 2 + 25,
      -size.height / 2 + 25,
      size.width - 50,
      size.height - 50,
    );

    final paint = Paint()
      ..colorFilter =
          ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.softLight)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = kContourColor.withOpacity(0.1)
      ..strokeWidth = 15;

    final reflection = Path()
      ..addArc(rect, vector.radians(-10), vector.radians(35))
      ..addArc(rect, vector.radians(40), vector.radians(15))
      ..addArc(rect, vector.radians(70), vector.radians(5));

    canvas.drawPath(reflection, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _FlaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      -size.width / 2,
      -size.height / 2,
      size.width,
      size.height,
    );

    final paint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = kContourColor
      ..strokeWidth = 10;

    final flask = Path()
      ..moveTo(
        math.sin(vector.radians(15)) * size.width / 2,
        -math.cos(vector.radians(15)) * size.height / 2 - 40,
      )
      ..arcTo(rect, vector.radians(-75), vector.radians(330), false)
      ..relativeLineTo(0, -40)
      ..close();

    final topRect = Rect.fromCenter(
      center: Offset(0, -size.height / 2 - 50),
      width: size.width / 3,
      height: 20,
    );
    final topRRect =
        RRect.fromRectAndRadius(topRect, const Radius.circular(10));
    flask.addRRect(topRRect);
    canvas.drawPath(flask, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..addOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width - 20,
        height: size.height - 20,
      ),
    );

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.isRightDirection,
    required this.animationController,
  });

  AnimationController animationController;
  final bool isRightDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final xOffset = size.width / 2;
    final polygonOffsets = <Offset>[];

    for (var i = -xOffset.toInt(); i <= xOffset; i++) {
      polygonOffsets.add(
        Offset(
          i.toDouble(),
          isRightDirection
              ? math.sin(
                        vector.radians(i.toDouble() * 360 / kWaveLength) -
                            vector.radians(animationController.value),
                      ) *
                      20 -
                  25
              : math.sin(
                        vector.radians(i.toDouble() * 360 / kWaveLength) +
                            vector.radians(animationController.value),
                      ) *
                      20 -
                  20,
        ),
      );
    }

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
      colors: const [
        kTopColor,
        kBottomColor,
      ],
      stops: [isRightDirection ? 0.1 : 0.4, isRightDirection ? 0.9 : 1],
    );

    final wave = Path()
      ..addPolygon(polygonOffsets, false)
      ..lineTo(xOffset, size.height)
      ..lineTo(-xOffset, size.height)
      ..close();

    final rect = Rect.fromLTWH(
      0,
      isRightDirection ? -size.height / 5 - 25 : -size.height / 5 - 22,
      size.width,
      size.height / 2,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(wave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
