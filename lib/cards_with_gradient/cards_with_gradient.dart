import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardsWithGradient extends StatelessWidget {
  late final List<String> titles;
  late final List<Gradient> gradients;

  CardsWithGradient({super.key}) {
    titles = [
      'Секция 1',
      'Секция 2',
      'Секция 3',
      'Секция 4',
      'Секция 5',
      'Секция 6',
      'Секция 7',
      'Секция 8',
    ];
    final quantityColorsForGradient = titles.length;
    const baseStartGradient = Color.fromARGB(255, 26, 227, 33);
    const baseFinishGradient = Color.fromARGB(255, 0, 73, 183);

    gradients = List.generate(
      titles.length,
      (index) {
        final k1 = index / quantityColorsForGradient;
        final k2 = (index + 1) / quantityColorsForGradient;

        final startGradient =
            Color.lerp(baseStartGradient, baseFinishGradient, k1) ??
                baseStartGradient;
        final finishGradient =
            Color.lerp(baseStartGradient, baseFinishGradient, k2) ??
                baseFinishGradient;

        return LinearGradient(
          colors: [
            startGradient,
            finishGradient,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SizedBox(
            height: 50,
            child: CardsWidgets(
              titles: titles,
              gradients: gradients,
            ),
          ),
        ),
      ),
    );
  }
}

class CardsWidgets extends StatelessWidget {
  final List<String> titles;
  final List<Gradient> gradients;

  const CardsWidgets({
    super.key,
    required this.titles,
    required this.gradients,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        titles.length,
        (index) => Padding(
          padding: EdgeInsets.only(right: titles.length - 1 > index ? 30 : 0),
          child: CardWidget(
            title: titles[index],
            gradient: gradients[index],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final Gradient gradient;

  const CardWidget({
    super.key,
    required this.title,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (kDebugMode) {
              print(title);
            }
          },
          child: Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: gradient,
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
