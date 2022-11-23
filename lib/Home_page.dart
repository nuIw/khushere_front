import 'package:final_p/Detail_page.dart';
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Get_data.dart';

class Home_page extends StatefulWidget {

  Map place = {"즐겨찾기": [], "식당": ["제2 기숙사 학생식당", "학생회관 식당", "우정원 푸드코트"], "헬스장": ["선승관 헬스장"], "단과대 열람실": ["공대 열람실", "자대 열람실", "동아리 방"]};
  Map drop_menu = {"즐겨찾기": false, "식당": false, "헬스장": false, "단과대 열람실": false};
  Map favo = {"제2 기숙사 학생식당": false, "학생회관 식당": false, "우정원 푸드코트": false, "선승관 헬스장": false, "공대 열람실": false, "자대 열람실": false, "동아리 방": false};
  Map current_percent = {"제2 기숙사 학생식당": 0.5, "학생회관 식당": 0.2, "우정원 푸드코트": 0.1, "선승관 헬스장": 0.3, "공대 열람실": 0.5, "자대 열람실": 0.2, "동아리 방": 0.1}; //test 를 위한 임의의 값 전달.

  Home_page() {//생성자
    GetFavoData();
    Settrafficdata();
  }

  void Settrafficdata() async{
    List<dynamic> data = await getTraffic(1);
    current_percent["동아리 방"] = data[0];
  }

  void GetFavoData() async {
    //가져오기
    var pref = await SharedPreferences.getInstance();
    for (var i in favo.keys) {
      bool? temp = pref.getBool(i);
      if (temp == true) {
        favo[i] = temp;
        place["즐겨찾기"].add(i);
      } else if (temp == false) {favo[i] = temp;}
    }
  }

  void UpdateFavoData(String key, bool value) async {
    //저장
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "경희대학교 국제캠퍼스",
            style: TextStyle(
                fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
          leading: Image(image: AssetImage("asset/khu.png"))),
      body: ListView(
        children: [
          for (var up in widget.place.keys)
            Column(
              children: [
                const Divider(thickness: 1, color: Colors.black, height: 0.0),
                ListTile(
                    leading: ButtonTheme(
                      child: IconButton(
                        icon: drop_icon(widget.drop_menu[up]),
                        onPressed: () {
                          setState(() {
                            widget.drop_menu[up] = !widget.drop_menu[up];
                          });
                        },
                        iconSize: 50,
                      ),
                    ),
                    title: Text(up,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                if (widget.drop_menu[up])
                  for (var down in widget.place[up])
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ButtonTheme(
                          //즐겨찾기 버튼
                            child: IconButton(
                              icon: favorite_icon(widget.favo[down]),
                              // 즐겨찾기 버튼이 있는 항목만 채워짐 표시
                              onPressed: () {
                                setState(() {
                                  if (widget.favo[down]) {
                                    toast_bottom("${down}이(가) 즐겨찾기에 취소됐습니다");
                                    for (int i = 0;
                                    i < widget.place["즐겨찾기"].length;
                                    i++) {
                                      if (widget.place["즐겨찾기"][i] == down) {
                                        widget.place["즐겨찾기"].removeAt(i);
                                        break;
                                      }
                                    }
                                  } else {
                                    toast_bottom("${down}이(가) 즐겨찾기에 등록됐습니다");
                                    widget.place["즐겨찾기"].add(down);
                                  }
                                  widget.favo[down] = !widget.favo[down];
                                  widget.UpdateFavoData(down, widget.favo[down]);
                                });
                              },
                            )),
                        ButtonTheme(
                            child: TextButton(
                              onPressed: () {
                                setState(() async{
                                  if(down == "동아리 방"){
                                    List data = await getTraffic(7);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Detail_page(place_name: down,day_percent: data)
                                        )
                                    );
                                  }
                                  else{
                                    List data = await getTraffic(7);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Detail_page(place_name: down,day_percent: [0.1,0.3,0.9,0.3,0.8,0.2,0.4])//동아리 방 아닌 장소는 임의의 값 전달
                                        )
                                    );
                                  }
                                }
                                );
                              },
                              child: Text(down,
                                  style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                            )),
                        LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 200,
                          animation: true,
                          animationDuration: 850,
                          percent: widget.current_percent[down],
                          lineHeight: 20,
                          progressColor:
                          progress_bar(widget.current_percent[down]),
                          barRadius: const Radius.circular(16),
                        ),
                      ],
                    ),
              ],
            ),
          const Divider(thickness: 1, color: Colors.black, height: 0.0)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        //새로고침 버튼
        child: Icon(Icons.refresh),
        backgroundColor: Colors.black,
        onPressed: () {
          setState(() {
            widget.Settrafficdata(); //여기 double 값만 불러오면 됨.
          });
        },
      ),
    );
  }
}

MaterialAccentColor progress_bar(double per) {
  //progress bar 구현
  if (per > 0.75) {
    return Colors.redAccent;
  } else if (per >= 0.5) {
    return Colors.blueAccent;
  } else {
    return Colors.greenAccent;
  }
}

Icon drop_icon(bool is_drop) {
  if (is_drop) {
    return const Icon(
      Icons.keyboard_arrow_down,
      size: 40,
    );
  }
  return const Icon(
    Icons.keyboard_arrow_right,
    size: 40,
  );
}

Icon favorite_icon(bool is_favo) {
  if (is_favo) return const Icon(Icons.favorite, color: Colors.red);
  return const Icon(Icons.favorite_border_outlined);
}

void toast_bottom(String msg) {
  Fluttertoast.showToast(
      msg: '${msg}',
      gravity: ToastGravity.BOTTOM,
      fontSize: 15.0,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      toastLength: Toast.LENGTH_SHORT);
}
