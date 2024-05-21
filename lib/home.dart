import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather/model/model.dart';
import 'package:weather/util/covertdate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:intl/intl.dart';
// import 'package:gradient_icon/gradient_icon.dart';
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

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
        drawer: const Drawer(child: Text("My Drawer")),
        appBar: AppBar(
          title: const Text('រាជធានីភ្នំពេញ'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: WeatherScreen(),
      ),
    );
  }
}


// ignore: use_key_in_widget_constructors
class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherModel?>(
      future: getDataFromAPI(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while the data is being fetched
          EasyLoading.show(status: 'loading...');
          return const SizedBox();
        } else {
          // Dismiss loading indicator when the data is fetched
          EasyLoading.dismiss();
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            WeatherModel m = snapshot.data!;
            KhmerDateFormatter formatter = KhmerDateFormatter();
            String khmerDate = formatter.convert(m.current!.dt!);
            String weatherIcon = m.current!.weather![0].icon!;
            String iconUrl =
                'https://openweathermap.org/img/wn/$weatherIcon@2x.png';

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade500,
                              Colors.blue.shade700
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0, 1),
                              blurRadius: 2)
                        ]),
                    child: Column(
                      children: [
                        Text(
                          khmerDate,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              iconUrl,
                              width: 64,
                              height: 64,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${m.current!.temp!}°C",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 34),
                                ),
                                Text(
                                  convertWeatherToKhmer(
                                      m.current?.weather?[0]?.main ?? ''),
                                  style:
                                      const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Text(
                          "អតិបរមា33°C  អប្បបរមា 20°C",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Text("ព្យាករណ៍ប្រចាំថ្ងៃ"),
                      Icon(Icons.help_outline),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          )
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("ព្រឹក\n${m.hourly![6].temp}°C", textAlign: TextAlign.center),
                        Text("ថ្ងៃ\n${m.hourly![12].temp}°C", textAlign: TextAlign.center),
                        Text("រសៀល\n${m.hourly![15].temp}°C", textAlign: TextAlign.center),
                        Text("យប់\n${m.hourly![20].temp}°C", textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  const Text("ព្យាករណ៍ប្រចាំម៉ោង"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BlueBackground(),
                          child: Column(
                            children: [
                              const Text("NOW",
                                  style: TextStyle(color: Colors.white)),
                              Text(
                                  // ignore: unnecessary_string_interpolations
                                  '${convertUnixTimestampToTime(m.current!.dt!)}',
                                  style:
                                      const TextStyle(color: Colors.white)),
                              Image.network(
                                'https://openweathermap.org/img/wn/${m.hourly![0].weather![0].icon}@2x.png',
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("${m.hourly![0].temp!}°C",
                                  style:
                                      const TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                        Hourly(
                            convertUnixTimestampToDate(m.hourly![1].dt!),
                            // ignore: unnecessary_string_interpolations
                            "${convertUnixTimestampToTime(m.hourly![1].dt!)}",
                            m.hourly![1].weather![0].icon!,
                            "${m.hourly![1].temp!}°C"),
                        Hourly(
                            convertUnixTimestampToDate(m.hourly![2].dt!),
                            // ignore: unnecessary_string_interpolations
                            "${convertUnixTimestampToTime(m.hourly![2].dt!)}",
                            m.hourly![2].weather![0].icon!,
                            "${m.hourly![2].temp!}°C"),
                        Hourly(
                            convertUnixTimestampToDate(m.hourly![3].dt!),
                            // ignore: unnecessary_string_interpolations
                            "${convertUnixTimestampToTime(m.hourly![3].dt!)}",
                            m.hourly![3].weather![0].icon!,
                            "${m.hourly![3].temp!}°C"),
                        Hourly(
                            convertUnixTimestampToDate(m.hourly![4].dt!),
                            // ignore: unnecessary_string_interpolations
                            "${convertUnixTimestampToTime(m.hourly![4].dt!)}",
                            m.hourly![4].weather![0].icon!,
                            "${m.hourly![4].temp!}°C"),
                        Hourly(
                            convertUnixTimestampToDate(m.hourly![5].dt!),
                            // ignore: unnecessary_string_interpolations
                            "${convertUnixTimestampToTime(m.hourly![5].dt!)}",
                            m.hourly![5].weather![0].icon!,
                            "${m.hourly![5].temp!}°C"),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Row(
                      children: [Text("លម្អិត"), Icon(Icons.help_outline)],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: WhiteBackground(),
                    child: Column(children: [
                      DetailRow(
                          "ថ្ងៃរះ",
                          CupertinoIcons.sunrise_fill,
                          convertUnixToTime(m.current!.sunrise!),
                          "ថ្ងៃលិច",
                          CupertinoIcons.sunset,
                          convertUnixToTime(m.current!.sunset!)),
                      const Divider(),
                      DetailRow(
                          "ទឹកសន្សើម",
                          CupertinoIcons.sunrise_fill,
                          "${m.current!.dewPoint!}%",
                          "សំណើម",
                          CupertinoIcons.cloud_rain,
                          "${m.current!.humidity!}%"),
                      const Divider(),
                      DetailRow(
                          "ល្បឿនខ្យល់",
                          CupertinoIcons.wind,
                          "${m.current!.windSpeed!}%",
                          "ទិសដៅខ្យល់",
                          CupertinoIcons.wind,
                          "${m.current!.windDeg!}°"),
                      const Divider(),
                      DetailRow(
                          "សម្ពាធ",
                          CupertinoIcons.alt,
                          "${m.current!.pressure!}hPa",
                          "ពពក",
                          CupertinoIcons.cloud,
                          "${m.current!.clouds!}%"),
                      const Divider(),
                      DetailRow(
                          "កាំរស្មីUV",
                          CupertinoIcons.sunrise_fill,
                          "${m.current!.uvi!}",
                          "ភាពមើលឃើញ",
                          CupertinoIcons.eye,
                          "${m.current!.visibility!} km"),
                    ]),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No data found'),
            );
          }
        }
      },
    );
  }

  // ignore: non_constant_identifier_names
  Row DetailRow(v1, v2, v3, v4, v5, v6) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Row(
              children: [
                Text(v1),
                Icon(v2, color: Colors.yellow),
              ],
            ),
            Text(
              v3,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Text(v4),
                Icon(v5, color: Colors.orange),
              ],
            ),
            Text(
              v6,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )
          ],
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  BoxDecoration BlueBackground() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(0, 1), blurRadius: 2)
        ]);
  }

  // ignore: non_constant_identifier_names
  BoxDecoration WhiteBackground() {
    return BoxDecoration(
        gradient: const LinearGradient(colors: [
          Colors.white,
          Color.fromARGB(255, 234, 234, 234),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(0, 1), blurRadius: 2)
        ]);
  }

  // ignore: non_constant_identifier_names
  Container Hourly(var v1, var v2, String iconCode, var v4) {
    String iconUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Colors.white,
            Color.fromARGB(255, 234, 234, 234),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(0, 1), blurRadius: 2)
          ]),
      child: Column(
        children: [
          Text(v1, style: const TextStyle(color: Colors.grey)),
          Text(v2, style: const TextStyle(color: Colors.black)),
          Image.network(iconUrl, width: 32, height: 32),
          const SizedBox(
            height: 8,
          ),
          Text(v4, style: const TextStyle(color: Colors.black))
        ],
      ),
    );
  }
}

