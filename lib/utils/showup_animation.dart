import 'dart:async';

import 'package:flutter/cupertino.dart';

class ShowUp extends StatefulWidget {
  Widget child;
  int delay;

  ShowUp({required this.child, this.delay = 0});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );

    final _curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);

    _animOffset = Tween<Offset>(begin: Offset(0.0, 0.35), end: Offset.zero).animate(_curve);

    if(widget.delay == 0) {
      _controller.forward();
    }
    else {
      Timer(Duration(seconds: widget.delay), () {_controller.forward();});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _controller,
      child: SlideTransition(
        child: widget.child,
        position: _animOffset,
      ),
    );
  }
}
