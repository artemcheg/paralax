import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scroll/main.dart';

class Scroll extends StatefulWidget {
  const Scroll({Key? key}) : super(key: key);

  @override
  _ScrollState createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  List<String> item = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg',
    'assets/5.jpg',
    'assets/6.jpg',
    'assets/7.jpg',
    'assets/8.jpg',
  ];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
      child: Transform.rotate(
        angle: 0.1,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 700, right: 700),
          clipBehavior: Clip.none,
          controller: controller,
          scrollDirection: Axis.horizontal,
          child: Stack(
            children: [
              Blur(item: item),
              Align(
                  alignment: Alignment.center,
                  child:
                      Row(
                        children: [
                          // Text("Text",style: TextStyle(fontSize: 50),),
                          Row(children: item.map((e) => Item(asset: e)).toList()),
                        ],
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String asset;
  Item({Key? key, required this.asset}) : super(key: key);

  final GlobalKey globalKeyImage = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.black.withOpacity(0.5),
                     spreadRadius: 10,
                     blurRadius: 15,
                     offset: const Offset(0, 0), // changes position of shadow
                   ),
                 ], ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: SizedBox(
              height: 700,
              width: 400,
              child: Flow(
                delegate: ParalaxDelegate(
                    scrollableState: Scrollable.of(context)!,
                    contextList: context,
                    globalKeyImage: globalKeyImage),
                children: [
                  Image.asset(
                    asset,
                    key: globalKeyImage,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Blur extends StatefulWidget {
  final List<String> item;

  const Blur({Key? key, required this.item})
      : super(key: key);

  @override
  _BlurState createState() => _BlurState();
}

class _BlurState extends State<Blur> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
          children: widget.item
              .map((e) => Stack(
            alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                          width: 520,
                          height: 980,
                          child: Image.asset(
                            e,
                            fit: BoxFit.cover,
                          )),
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 80,
                          sigmaY: 20,
                        ),
                        child: Container(
                          clipBehavior: Clip.none,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      )
                    ],
                  ))
              .toList()),
    );
  }
}

class ParalaxDelegate extends FlowDelegate {
  final ScrollableState scrollableState;
  final GlobalKey globalKeyImage;
  final BuildContext contextList;

  ParalaxDelegate(
      {required this.scrollableState,
      required this.globalKeyImage,
      required this.contextList})
      : super(repaint: scrollableState.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return const BoxConstraints.tightFor(height: 700);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox =
        scrollableState.context.findRenderObject() as RenderBox;
    // Передать контекст из SingleChildScrollView
    final listItemBox = contextList.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);
    final viewportDimension = scrollableState.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dx / viewportDimension).clamp(0.0, 1.0);
    final horizontalAlignment = Alignment(scrollFraction * 2 - 1, 0.0);

    final backgroundSize =
        (globalKeyImage.currentContext!.findRenderObject() as RenderBox).size;
    final listItemSize = context.size;
    final childRect = horizontalAlignment.inscribe(
        backgroundSize, Offset.zero & listItemSize);

    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(childRect.left, -1),
      ).transform,
    );
  }

  @override
  bool shouldRepaint(covariant ParalaxDelegate oldDelegate) {
    return scrollableState != oldDelegate.scrollableState ||
        globalKeyImage != oldDelegate.globalKeyImage ||
        contextList != oldDelegate.contextList;
  }
}
