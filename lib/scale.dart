import 'package:flutter/material.dart';

class ScrollAnimation extends StatefulWidget {
  final Widget child;
  final double offset;
  final Curve curve;
  final Duration durationStart;
  final Duration animTime;
  final Duration reverseDuration;

 final ScrollController controller;

  const ScrollAnimation({
    Key? key,
    required this.child,
    this.offset = 0.3,
    this.curve = Curves.decelerate,
    this.durationStart = const Duration(seconds: 0),
    this.animTime = const Duration(milliseconds: 1000), required this.controller, this.reverseDuration =const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  _ScrollAnimationState createState() => _ScrollAnimationState();
}

class _ScrollAnimationState extends State<ScrollAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animationSlide;
  late AnimationController _controller;
  late Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animTime,
      reverseDuration: widget.reverseDuration
    );

    _animationSlide =
        Tween<Offset>(begin: Offset(0, widget.offset), end: const Offset(0, 0))
            .animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _animationFade = Tween<double>(begin: 0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _controller.forward();

   widget.controller.addListener(() {start();});
  }

  void start() {

    if(widget.controller.offset>5){
      _controller.reverse();
    }else if(widget.controller.offset==0){
      _controller.forward();
    }

  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: _animationFade,
        child: SlideTransition(
          position: _animationSlide,
          child: widget.child,
        ),
      ),
    );
  }
}
