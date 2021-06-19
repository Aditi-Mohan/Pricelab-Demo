import 'package:flutter/cupertino.dart';

class NextPageRoute extends CupertinoPageRoute {
  Widget nextScreen;

  NextPageRoute({required this.nextScreen})
      : super(builder: (BuildContext context) => nextScreen);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: nextScreen);
  }
}
