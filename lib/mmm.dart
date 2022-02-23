import 'dart:ui';
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
  ];
  late LinkedScrollControllerGroup _controllers;
  late ScrollController controller;
  late ScrollController controller2;
  final String neon =
      'Неон – это элемент таблицы Менделеева, инертный газ без цвета и запаха, '
      'активно применяемый для уличного освещения (вывески и реклама). '
      'На самом деле, неоновый свет имеет красный оттенок, '
      'а для получения всех прочих цветов в освещении используют ртуть и фосфор '
      'в определенных пропорциях. Выражение "неоновые цвета" с этой точки зрения неверно, '
      'правильнее было бы говорить "флуоресцентные цвета", когда говорят о кричащих, "кислотных" оттенках.';

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
      colors: [Color(0xffD3006E), Color(0xffff6347), Color(0xff861098)]);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
      padding: const EdgeInsets.only(left: 50),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                child: ScrollAnimation(
                  reverseDuration: const Duration(seconds: 2),
                  controller: controller,
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) => gradient.createShader(
                        Rect.fromLTWH(1, 10, bounds.width * 2, bounds.height)),
                    child: const Text(
                      'NEON',
                      style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(color: Color(0xffD3006E), blurRadius: 15),
                            Shadow(color: Color(0xffff6347), blurRadius: 8),
                            Shadow(color: Color(0xff861098), blurRadius: 2)
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
                    width: 400,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 450, right: 700),
          clipBehavior: Clip.none,
          controller: controller,
          scrollDirection: Axis.horizontal,
          child: RepaintBoundary(
            child: Align(
                alignment: Alignment.center,
                child: Row(
                    children: item
                        .map((e) => Item(
                              asset: e,
                            ))
                        .toList())),
          ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 200),
          clipBehavior: Clip.none,
          controller: controller,
          scrollDirection: Axis.horizontal,
          child: Align(
              alignment: Alignment.center,
              child: Row(children: item.map((e) => Blur(item: e)).toList())),
        ),
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
                borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                        widget.asset,
                        isAntiAlias: true,
                        key: globalKeyImage,
                        fit: BoxFit.cover,
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
          SizedBox(
              width: 500,
              height: 980,
              child: Image.asset(
                widget.item,
                fit: BoxFit.cover,
              )),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 30,
              sigmaY: 20,
            ),
            child: Container(
              clipBehavior: Clip.none,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          )
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
