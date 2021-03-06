import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/constants.dart';
import 'package:http/http.dart' as http;
import 'package:expand_widget/expand_widget.dart';

class InfoScene extends StatefulWidget {
  final String idParam;
  final String typeParam;
  const InfoScene({
    Key key,
    this.idParam,
    this.typeParam,
  }) : super(key: key);

  @override
  InfoSceneState createState() => InfoSceneState(idParam, typeParam);
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class InfoSceneState extends State<InfoScene> {
  String accessToken;

  final String idParam;
  final String typeParam;
  InfoSceneState(this.idParam, this.typeParam);

  String valueStatus;
  List animeStatus = [
    "watching",
    "completed",
    "on_hold",
    "dropped",
    "plan_to_watch",
    "currently_airing",
  ];

  _loadStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.accessToken = prefs.getString('access_token');
  }

  _printRecommendations(listRecommendations) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Text(
        'Recommendations',
        style: TextStyle(
            fontSize: 25, color: kSecondaryColor, fontWeight: FontWeight.w700),
      ),
      SizedBox(
        height: 200.0,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listRecommendations.length,
          itemBuilder: (BuildContext context, int index) => Card(
            child: Center(
                child: Image.network(
              listRecommendations[index]['node']['main_picture']['large'],
            )),
          ),
        ),
      ),
    ]);
  }

  _checkInfoEpisode(infoMap) {
    return infoMap['my_list_status'] == null
        ? 0
        : infoMap['my_list_status']['num_episodes_watched'];
  }

  _checkInfoStatus(infoMap) {
    return infoMap['my_list_status'] == null
        ? Text(
            'Not in your list',
            style: TextStyle(color: kSecondaryColor),
          )
        : Text(
            infoMap['my_list_status']['status'],
            style: TextStyle(color: kSecondaryColor),
          );
  }

  _printGenres(listGenre) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listGenre.length,
          itemBuilder: (BuildContext context, int index) => Container(
                  child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kSecondaryColor,
                      ),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(listGenre[index]['name'],
                          style: TextStyle(color: kSecondaryColor)),
                    )),
              ))),
    );
  }

  void _updateAnime(String status, int nbrWatchedEpisodes, String id) async {
    var response = await http.patch(
      'https://api.myanimelist.net/v2/anime/' + id + '/my_list_status',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
      body: {
        'status': status,
        'num_watched_episodes': nbrWatchedEpisodes.toString(),
      },
    );
    print(response.body);
  }

  Future<http.Response> getInfosAnimeMangas(String id, String type) async {
    await _loadStorage();
    var response = http.get(
      'https://api.myanimelist.net/v2/' +
          type +
          '/' +
          id +
          '?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
    return (response);
  }

  Widget _buildInfo(info) {
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
                        image: NetworkImage(infoMap['main_picture']['large']),
                        fit: BoxFit.cover)),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: Alignment(0.0, 2.5),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(infoMap['main_picture']['medium']),
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
                    infoMap['title'],
                    style: TextStyle(
                      fontSize: 25.0,
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DropdownButton(
                  hint: _checkInfoStatus(infoMap),
                  value: valueStatus,
                  onChanged: (newValue) {
                    setState(() {
                      valueStatus = newValue;
                      _updateAnime(valueStatus, _checkInfoEpisode(infoMap),
                          this.idParam);
                    });
                  },
                  items: animeStatus.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(
                        valueItem,
                        style: TextStyle(color: ktmp),
                      ),
                    );
                  }).toList(),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(80, 2, 2, 2),
                  child: Row(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          _updateAnime(infoMap['my_list_status']['status'],
                              _checkInfoEpisode(infoMap) + 1, this.idParam);
                        },
                        elevation: 2.0,
                        fillColor: kSecondaryColor,
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                        padding: EdgeInsets.all(3.0),
                        shape: CircleBorder(),
                      ),
                      Text(
                        _checkInfoEpisode(infoMap).toString() +
                            ' / ' +
                            infoMap['num_episodes'].toString(),
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _updateAnime(infoMap['my_list_status']['status'],
                              _checkInfoEpisode(infoMap) - 1, this.idParam);
                        },
                        elevation: 2.0,
                        fillColor: kSecondaryColor,
                        child: Icon(
                          Icons.remove,
                          size: 30,
                        ),
                        padding: EdgeInsets.all(3.0),
                        shape: CircleBorder(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(2, 15, 2, 0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: <Widget>[
                    Text(
                      'Synopsis',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: kSecondaryColor,
                      ),
                    ),
                    ExpandText(
                      infoMap['synopsis'],
                      style: TextStyle(color: kButtonColor),
                      arrowColor: kSecondaryColor,
                    ),
                  ])),
            ),
            Divider(
              thickness: 2,
              height: 20,
              color: kSecondaryColor,
              indent: 30,
              endIndent: 30,
            ),
            Container(child: _printGenres(infoMap['genres'])),
            Divider(
              thickness: 2,
              height: 20,
              color: kSecondaryColor,
              indent: 30,
              endIndent: 30,
            ),
            Container(child: _printRecommendations(infoMap['recommendations'])),
            // Text('dsqmldskmqdksm'),
          ],
        ),
      ),
    ));
  }

  Widget printScene() {
    return Scaffold(
      body: FutureBuilder(
        future: getInfosAnimeMangas(this.idParam, this.typeParam),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return _buildInfo(snapshot.data);
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
      appBar: AppBar(
        title: const Text('Info'),
        backgroundColor: kSecondaryColor,
      ),
      body: printScene(),
    );
  }
}
