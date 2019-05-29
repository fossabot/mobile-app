import 'package:flutter/material.dart';
import 'package:inkstep/main.dart';

class UserFlowButton extends StatelessWidget {
  UserFlowButton({
    this.destination,
    Key key,
  }) : super(key: key);

  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(context,
            MaterialPageRoute<dynamic>(builder: (context) => destination));
      },
      child: Text(
        "I'M ON A NEW DEVICE",
        style: TextStyle(
          color: baseColors['light'],
          fontSize: 15.0,
          fontFamily: 'Signika',
        ),
      ),
    );
  }
}
