import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// can't have more than 1 logo on a screen
class Logo extends StatefulWidget {
  final double width;
  final double height;

  Logo({required this.height, required this.width});
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height < (57+8) ? 57+8 : widget.height,
      width: widget.width < (189+(19*4)+(5*4)) ? (189+(19*4)+(5*4)) : widget.width,
      child: Center(
        child: Container(
          //color: Colors.red,
          height: 57+8,
          width: (189+(19*4)+(5*4)),
          child: Stack(
            children: [
              Positioned(
                left: (19*4)+(5*4),
                top: 8,
                child: Hero(
                  tag: 'name',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text("Pricelab",
                      style: TextStyle(
                        color: Color.fromRGBO(28, 202, 150, 1),
                        fontWeight: FontWeight.w600,
                        fontSize: 42,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (19*3)+(5*3),
                top: 8,
                child: Hero(
                  tag: 'box1',
                  child: Container(
                    width: 19,
                    height: 57,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF71F533), Color(0xFF197050)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (19*2)+(5*2),
                child: Hero(
                  tag: 'box2',
                  child: Container(
                    width: 19,
                    height: 57,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 19+5,
                top: 8,
                child: Hero(
                  tag: 'box3',
                  child: Container(
                    width: 19,
                    height: 57,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF44C508), Color(0xFF1A1F1C)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: Hero(
                  tag: 'box4',
                  child: Container(
                    width: 19,
                    height: 57,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
