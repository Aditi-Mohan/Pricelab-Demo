import 'package:flutter/cupertino.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color.fromRGBO(193, 193, 193, 1))
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              child: Image(image: AssetImage("assets/images/google-logo.png"),),
            ),
            Text("Use Google Account",
              style: TextStyle(
                color: Color.fromRGBO(104, 132, 95, 0.75),
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }
}
