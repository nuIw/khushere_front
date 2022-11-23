import 'package:final_p/Home_page.dart';
import "package:flutter/material.dart";
import 'dart:async';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 3), ()
    {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home_page())//여기 home_page 생성자에 double형 데이터 쏘면 됨.
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(50),
                child: const Image(image: AssetImage("asset/khu.png")),
              ),
              const SizedBox(height: 30),
              const Text("경희대학교 공간 혼잡도 제공 서비스",
                  style: TextStyle(fontSize: 23, color: Colors.black,fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              const Text("@by ParkCSU,Jominwoo,HwangHyoeun",
                  style: TextStyle(fontSize: 15, color: Colors.grey))
            ],
          ),
        )
    );
  }
}
