import 'package:flutter/material.dart';

class ScaleAnimation extends StatefulWidget {
  final Widget child;
  final double beginScale;
  final double endScale;
  final Duration duration;


  const ScaleAnimation(
      {Key? key,
        required this.child,
        this.beginScale = 1.3,
        this.endScale = 1,
        this.duration = const Duration(seconds: 1),})
      : super(key: key);

  @override
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _animation;
  late final Animation<double> _turn;
bool click = false;
  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.3)
        .animate(_controller);

    _turn = Tween<double>(begin: 0, end: -0.016)
        .animate(_controller);

    super.initState();
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          click = !click;
        });
        if(click){
          _controller.forward();
        }else{
          _controller.reverse();
        }
      },
      child: RepaintBoundary(
        child: RotationTransition(
          turns: _turn,
          child: ScaleTransition(
            scale: _animation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}


