import "package:flutter/material.dart";
import 'SplashScreen.dart';

void main() => runApp(const MyWidget());

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KHUshere",
      home: SplashScreen()
    );
  }
}
