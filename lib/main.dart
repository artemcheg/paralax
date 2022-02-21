import 'dart:ui';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:flutter/material.dart';
import 'package:scroll/sss.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> images = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Scroll()
      // ScrollWidget(images: images,),
    );
  }
}

class ScrollWidget extends StatefulWidget {
  final List<String> images;

  const ScrollWidget({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  _ScrollWidgetState createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends State<ScrollWidget> {
  double page = 0.0;
  late LinkedScrollControllerGroup _controllers;

  late PageController pageController;

  @override
  void initState() {

    pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.3,
    );

    pageController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    setState(() {
      page = pageController.page!;
      print(page);


    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(0.04),
            child: PageView.builder(
              scrollBehavior:
                  MyCustomScrollBehavior().copyWith(scrollbars: false),
              clipBehavior: Clip.none,
              controller: pageController,
              itemBuilder: (context, index) {
                return ParallaxImage(
                  url: widget.images[index],
                  horizontalSlide: (index - page).clamp(-1, 1).toDouble(),
                );
              },
              itemCount: widget.images.length,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    pageController.removeListener(_onScroll);
    pageController.dispose();
    super.dispose();
  }
}

class ParallaxImage extends StatelessWidget {
  final String url;
  final double horizontalSlide;

  const ParallaxImage({
    Key? key,
    required this.url,
    required this.horizontalSlide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final scale = 1 - horizontalSlide.abs();
    // final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: 500,
        height: 700,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset(
            url,
            alignment: Alignment(horizontalSlide, 1),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends ScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.stylus,
      };
}
