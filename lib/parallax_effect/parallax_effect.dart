import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _ParallaxEffect(),
      ),
    );
  }
}

class _ParallaxEffect extends StatefulWidget {
  const _ParallaxEffect();

  @override
  State<_ParallaxEffect> createState() => _ParallaxEffectState();
}

class _ParallaxEffectState extends State<_ParallaxEffect> {
  double _scrollOffset = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final layoutHeight = screenSize.height * 3;

    final layerSpeed1 = _scrollOffset * 0.5;
    final layerSpeed2 = _scrollOffset * 0.45;
    final layerSpeed3 = _scrollOffset * 0.42;
    final layerSpeed4 = _scrollOffset * 0.375;
    final sunSpeed = _scrollOffset * 0.25;

    final layerHSpeed1 = _scrollOffset * 0.1;
    final layerHSpeed2 = _scrollOffset * 0.08;
    final layerHSpeed3 = _scrollOffset * 0.075;
    final layerHSpeed4 = _scrollOffset * 0.07;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 66, 240, 210),
            Color.fromARGB(255, 253, 244, 193),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: screenSize.height * 0.5 + sunSpeed,
            right: screenSize.width * 0.3,
            child: SvgPicture.asset(
              'assets/images/parallax_effect/sun.svg',
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            bottom: layerSpeed4,
            right: -layerHSpeed4,
            left: -layerHSpeed4,
            child: SvgPicture.asset(
              'assets/images/parallax_effect/mountains_layer_4.svg',
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            bottom: layerSpeed3,
            right: -layerHSpeed3,
            left: -layerHSpeed3,
            child: SvgPicture.asset(
              'assets/images/parallax_effect/mountains_layer_2.svg',
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            bottom: layerSpeed2,
            right: -layerHSpeed2,
            left: -layerHSpeed2,
            child: SvgPicture.asset(
              'assets/images/parallax_effect/trees_layer_2.svg',
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            bottom: -20 + layerSpeed1,
            right: -layerHSpeed1,
            left: -layerHSpeed1,
            child: SvgPicture.asset(
              'assets/images/parallax_effect/layer_1.svg',
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            bottom: -screenSize.height + layerSpeed1,
            right: 0,
            left: 0,
            height: screenSize.height,
            child: const ColoredBox(
              color: Colors.black,
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                height: layoutHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
