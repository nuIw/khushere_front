import 'package:dio/dio.dart';

Future <List<dynamic>> getTraffic(int date) async{//서버로부터 데이터 요청
  const _API = "http://141.164.54.192";
  Response response = await Dio().get("${_API}/traffic/${date}");
  List <dynamic> return_data = response.data["data"];
  return return_data;
}