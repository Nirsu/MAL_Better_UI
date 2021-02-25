import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/constants.dart';
import 'package:http/http.dart' as http;
import 'package:expand_widget/expand_widget.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../Components/indicator.dart';

const nbr_Days_age = 8030;

class ProfileScene extends StatefulWidget {
  @override
  ProfileSceneState createState() => ProfileSceneState();
}

class ProfileSceneState extends State<ProfileScene> {
  String accessToken;
  int touchedIndex;

  _loadStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.accessToken = prefs.getString('access_token');
  }

  Future<http.Response> getProfileInfos() async {
    await _loadStorage();
    var response = http.get(
      'https://api.myanimelist.net/v2/users/@me?fields=anime_statistics',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
    return (response);
  }

  List<PieChartSectionData> showingSections(info) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          double valuePourcent =
              ((info['num_days_watched'] / nbr_Days_age) * 100).roundToDouble();
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: valuePourcent,
            title: valuePourcent.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          double valuePourcent =
              ((info['num_days_watching'] / nbr_Days_age) * 100)
                  .roundToDouble();
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: valuePourcent,
            title: valuePourcent.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          double valuePourcent =
              ((info['num_days_completed'] / nbr_Days_age) * 100)
                  .roundToDouble();
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: valuePourcent,
            title: valuePourcent.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          double lastDay = nbr_Days_age -
              info['num_days_completed'] -
              info['num_days_watching'] -
              info['num_days_watched'];
          double valuePourcent =
              ((lastDay / nbr_Days_age) * 100).roundToDouble();
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: valuePourcent,
            title: valuePourcent.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }

  _buildPieChart(info) {
    return PieChart(
      PieChartData(
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections(info)),
    );
  }

  Widget _buildProfil(info) {
    Map<String, dynamic> infoMap = jsonDecode(info.body);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://wallpaperaccess.com/full/1853716.jpg'),
                      fit: BoxFit.cover)),
              child: Container(
                width: double.infinity,
                height: 200,
                child: Container(
                  alignment: Alignment(0.0, 2.5),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(infoMap['picture']),
                    radius: 60.0,
                  ),
                ),
              )),
          SizedBox(
            height: 60,
          ),
          Column(
            children: <Widget>[
              Container(
                child: Text(
                  infoMap['name'],
                  style: TextStyle(
                    fontSize: 25.0,
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(2, 130, 2, 0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: <Widget>[
                      _buildPieChart(infoMap['anime_statistics'])
                    ])),
              ),
              Column(
                children: <Widget>[
                  Indicator(
                    color: Color(0xff0293ee),
                    text: 'Nbr Days \nWatched %\n(' +
                        infoMap['anime_statistics']['num_days_watched']
                            .toString() +
                        'days)',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xfff8b250),
                    text: 'Nbr Days \nWatching %\n(' +
                        infoMap['anime_statistics']['num_days_watching']
                            .toString() +
                        'days)',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xff845bef),
                    text: 'Nbr Days \nCompleted %\n(' +
                        infoMap['anime_statistics']['num_days_completed']
                            .toString() +
                        'days)',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xff13d38e),
                    text: 'Nbr Days \n22y %\n(8030 days)',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              )
            ],
          ),
          Divider(
            thickness: 2,
            height: 20,
            color: kSecondaryColor,
            indent: 30,
            endIndent: 30,
          ),
        ]))));
  }

  Widget printProfilScene() {
    return Scaffold(
      body: FutureBuilder(
        future: getProfileInfos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return _buildProfil(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: kPrimaryColor,
        ),
      ),
      body: printProfilScene(),
    );
  }
}
