import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Parallax Effect'),
        ),
        body: const _ParallaxScrollingEffect(),
      ),
    );
  }
}

class _ParallaxScrollingEffect extends StatelessWidget {
  const _ParallaxScrollingEffect();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 3000,
      itemCount: 15,
      itemBuilder: (_, index) {
        return _Item(index);
      },
    );
  }
}

class _Item extends StatelessWidget {
  final keyImage = GlobalKey();
  final int index;

  _Item(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Flow(
        delegate: ParallaxFlowDelegate(
          scrollable: Scrollable.of(context)!,
          itemContext: context,
          keyImage: keyImage,
        ),
        children: [
          Image.network(
            'https://source.unsplash.com/random/300x800?sig=$index',
            fit: BoxFit.cover,
            key: keyImage,
          ),
        ],
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext itemContext;
  final GlobalKey keyImage;

  ParallaxFlowDelegate({
    required this.scrollable,
    required this.itemContext,
    required this.keyImage,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: constraints.maxWidth);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox?;
    final itemBox = itemContext.findRenderObject() as RenderBox?;
    final itemOffset = itemBox?.localToGlobal(
      itemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction = (itemOffset!.dy / viewportDimension).clamp(0, 1);

    final verticalAlignment = Alignment(0, scrollFraction * 2 - 1);
    final imageBox = keyImage.currentContext?.findRenderObject() as RenderBox;
    final childRect = verticalAlignment.inscribe(
      imageBox.size,
      Offset.zero & context.size,
    );
    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(0, 0),
      ).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        itemContext != oldDelegate.itemContext ||
        keyImage != oldDelegate.keyImage;
  }
}
