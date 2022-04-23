import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:scroll/main.dart';
import 'package:scroll/rotate_anim.dart';
import 'package:scroll/scale.dart';

class Scroll2 extends StatefulWidget {
  const Scroll2({Key? key}) : super(key: key);

  @override
  _Scroll2State createState() => _Scroll2State();
}

class _Scroll2State extends State<Scroll2> {
  List<String> item = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg',
    'assets/5.jpg',
    'assets/6.jpg',
    'assets/7.jpg',
    'assets/8.jpg',
    'assets/9.jpg',
    'assets/10.jpg',
    'assets/11.jpg',
    'assets/12.jpg',
    'assets/13jpg',
    'assets/14.jpg',
    'assets/15.jpg',
    'assets/16.jpg',
    'assets/17.jpg',
    'assets/18.jpg',
    'assets/19.jpg',
    'assets/20.jpg',
  ];
  late LinkedScrollControllerGroup _controllers;
  late ScrollController controller;
  late ScrollController controller2;
  final String neon =
      'Лес — составная часть природы, понятие «лес» можно рассматривать на разных уровнях. В глобальном масштабе — это часть биосферы, в локальном — это может быть насаждение. Лес также можно рассматривать как природно-зональное подразделение, как провинциальное подразделение, как лесной массив (Шипов лес, Шатилов лес, Чёрный лес), как экосистему. Леса занимают около трети площади суши, площадь леса на Земле составляет 38 млн км². Из них 264 млн га, или 7 %, посажены человеком, к началу XXI века человек уничтожил около 50 % площадей лесов, ранее существовавших на планете. Половина лесной зоны принадлежит тропическим лесам. Площади, занятые деревьями с сомкнутостью крон менее 0,2—0,3, считаются редколесьем.';

  @override
  void initState() {
    _controllers = LinkedScrollControllerGroup();
    controller = _controllers.addAndGet();
    controller2 = _controllers.addAndGet();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  late Gradient gradient = const LinearGradient(
      transform: GradientRotation(0.45),
      colors: [Color(0xff5eef77), Color(0xff3ba25e), Color(0xff6adaab)]);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MainScroll2(
          controller: controller2,
          item: item,
        ),
        TextInfo(
          controller: controller,
          gradient: gradient,
          neon: neon,
        ),
        MainScroll(controller: controller, item: item),
      ],
    );
  }
}

class TextInfo extends StatelessWidget {
  const TextInfo({
    Key? key,
    required this.gradient,
    required this.neon,
    required this.controller,
  }) : super(key: key);

  final Gradient gradient;
  final String neon;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                child: ScrollAnimation(
                  reverseDuration: const Duration(seconds: 1),
                  controller: controller,
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) => gradient.createShader(
                        Rect.fromLTWH(1, 10, bounds.width * 6, bounds.height)),
                    child: const Text(
                      'ЛЕС',
                      style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(color: Color(0xff53f320), blurRadius: 10),
                            Shadow(color: Color(0xff93c21d), blurRadius: 8),
                            Shadow(color: Color(0xff329d79), blurRadius: 2)
                          ],
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              RepaintBoundary(
                child: ScrollAnimation(
                  controller: controller,
                  offset: 0.1,
                  animTime: const Duration(seconds: 2),
                  reverseDuration: const Duration(seconds: 1),
                  durationStart: const Duration(milliseconds: 500),
                  child: SizedBox(
                    width: 600,
                    child: Text(
                      neon,
                      style: TextStyle(
                        color: Colors.white70.withOpacity(0.8),
                        fontSize: 20,
                        height: 1.5,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class MainScroll extends StatelessWidget {
  const MainScroll({
    Key? key,
    required this.controller,
    required this.item,
  }) : super(key: key);

  final ScrollController controller;
  final List<String> item;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
      child: Transform.rotate(
        angle: 0.1,
        //подключаем скролл мышкой колесиком
        child: Listener(
          onPointerSignal: (e) {
            List<double> list = [];
            if (e is PointerScrollEvent) {
              list.add(e.scrollDelta.dy);
              for (var element in list) {
                controller.animateTo(controller.offset + (element*2),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.linear);
              }
            }
          },
          child: ListView(
              padding: const EdgeInsets.only(left: 650, right: 700),
              clipBehavior: Clip.none,
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: [
                RepaintBoundary(
                  child: Align(
                      alignment: Alignment.center,
                      child: Row(
                          children: item
                              .map((e) => Item(
                                    asset: e,
                                  ))
                              .toList())),
                ),
              ]),
        ),
      ),
    );
  }
}

class MainScroll2 extends StatelessWidget {
  const MainScroll2({
    Key? key,
    required this.controller,
    required this.item,
  }) : super(key: key);

  final ScrollController controller;
  final List<String> item;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
      child: Transform.rotate(
        angle: -0.1,
        child: ListView(
            padding: const EdgeInsets.only(left: 200),
            clipBehavior: Clip.none,
            controller: controller,
            scrollDirection: Axis.horizontal,
            children: [
              Align(
                  alignment: Alignment.center,
                  child:
                      Row(children: item.map((e) => Blur(item: e)).toList())),
            ]),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final String asset;

  const Item({Key? key, required this.asset}) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final GlobalKey globalKeyImage = GlobalKey();
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: ScaleAnimation(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(255, 0, 0, 0)),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 15,
                    blurRadius: 40,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: SizedBox(
                  height: 700,
                  width: 550,
                  child: Flow(
                    delegate: ParalaxDelegate(
                        scrollableState: Scrollable.of(context)!,
                        contextList: context,
                        globalKeyImage: globalKeyImage),
                    children: [
                      Image.asset(
                        widget.asset,
                        key: globalKeyImage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Blur extends StatefulWidget {
  final String item;

  const Blur({Key? key, required this.item}) : super(key: key);

  @override
  _BlurState createState() => _BlurState();
}

class _BlurState extends State<Blur> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.6,
            child: ColorFiltered(
                colorFilter: const ColorFilter.linearToSrgbGamma(),
                child: Image.asset(
                  widget.item,
                  scale: 0.4,
                  // height: 5000,
                  // fit: BoxFit.fitHeight,
                )),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 50),
            child: Container(
              // clipBehavior: Clip.none,
              color: Colors.black,
            ),
          ),
        ],
      ),
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
    return BoxConstraints.tightFor(
      height: 700,
    );
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
        (listItemOffset.dx / viewportDimension).clamp(-0.5, 1.0);
    final horizontalAlignment = Alignment(scrollFraction * 2 - 1, 0.0);

    final backgroundSize =
        (globalKeyImage.currentContext!.findRenderObject() as RenderBox).size;
    final listItemSize = context.size;
    final childRect = horizontalAlignment.inscribe(
        backgroundSize, Offset.zero & listItemSize);

    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(childRect.left, 0),
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
