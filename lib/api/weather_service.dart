import 'dart:convert';
import 'package:http/http.dart';
import '../Model/model.dart';

class Weather {
  Future<WeatherModel?> getDataFromAPI() async {
  Response r = await get(Uri.parse(
      "https://api.openweathermap.org/data/3.0/onecall?lat=13.085918&lon=103.222597&exclude=minutely&appid=c6ec714d1237aa85d0a1dc47079a20a4&units=metric"));

  if (r.statusCode == 200) {
    // ignore: avoid_print
    print(r.body);
    return WeatherModel.fromJson(jsonDecode(r.body));

  } else {
    // ignore: avoid_print
    print('error');
    return null;
  }
}
}
