import 'package:final_p/Home_page.dart';
import "package:flutter/material.dart";
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Detail_page extends StatefulWidget {
  Detail_page({required this.place_name, required this.day_percent, super.key});//생성자- homepage에서 넘어올 때 값 받아올거임.
  String place_name = "";
  final Map place_data = {
    "제2 기숙사 학생식당": "점심 - 11:30 ~ 13:30 저녁 - 17:00 ~ 18:30",
    "학생회관 식당": "11:00 ~ 17:00",
    "우정원 푸드코트": "00:00",
    "선승관 헬스장": "07:00 ~ 21:00",
    "공대 열람실": "09:00  ~ 24:00",
    "자대 열람실": "09:00  ~ 24:00",
    "동아리 방" : "24시간 운영"
  };
  List day_percent = [];

  @override
  State<Detail_page> createState() => _Detail_pageState();
}


class _Detail_pageState extends State<Detail_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(widget.place_name,
                style: const TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold)),
            Text(widget.place_data[widget.place_name],
                style: const TextStyle(fontSize: 13, color: Colors.white))
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    "${widget.day_percent[6] * 100}%\n${progress_text(widget.day_percent[6])}",
                    style: const TextStyle(fontSize: 35,fontWeight: FontWeight.bold)),
                const SizedBox(width: 30),
                CircularPercentIndicator(
                  percent: widget.day_percent[6],
                  progressColor: progress_bar(widget.day_percent[6]),
                  backgroundColor: Colors.grey,
                  animation: true,
                  radius: 60,
                  reverse: true,
                  animationDuration: 850,
                  lineWidth: 100,
                )
              ],
            ),
            const Divider(
              thickness: 2,
              height: 70,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.noise_control_off),
                Text("혼잡도 기록(지난 주 이 시간대)", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              ],
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BarChart(
                BarChartData(titlesData: titlesData, maxY: 100, barGroups: [
                  for (int i = 0; i < widget.day_percent.length; i++)
                    BarChartGroupData(x: 6-i, barRods: [
                      BarChartRodData(
                          toY: widget.day_percent[i] * 100,
                          color: progress_bar(widget.day_percent[i]),
                          width: 17,
                          borderRadius: BorderRadius.circular(10))
                    ])
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(//새로고침 버튼
        child: Icon(Icons.refresh),
        backgroundColor: Colors.black,
        onPressed: () {
          setState(() {
            if(widget.place_name == "동아리 방"){//서버에서 받아온 값으로 day_percent 리스트 초기화 시켜주면 된다.
              //widget.day_percent = [list];
            }
          });
        },
      ),
    );
  }
}

FlTitlesData get titlesData => FlTitlesData(
  show: true,
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 30,
      getTitlesWidget: getTitles,
    ),
  ),
  topTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
);

Widget getTitles(double value, TitleMeta meta) {
  String text = get_month(value.toInt());
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(text, style: const TextStyle(fontSize: 10,)),
  );
}
String progress_text(double per) {
  //progress bar 구현
  if (per > 0.7) {
    return "혼잡해요!";
  } else if (per >= 0.5) {
    return "덜 혼잡해요!";
  } else {
    return "쾌적해요!";
  }
}

String get_month(int value) {
  var now = DateTime.now();
  if(value == 0) return "today";

  var result = now.subtract(Duration(days: value));
  String formatDate = "(${DateFormat("MM/dd").format(result)})";
  return formatDate;
}

String get_current_hour(){
  var now = DateTime.now();
  return DateFormat.jm().format(now);
}


