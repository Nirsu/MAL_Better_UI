import 'dart:convert';
import 'dart:io';

import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flappy_search_bar/flappy_search_bar.dart';

import '../../Components/customCard.dart';

class SearchScreen extends StatefulWidget {
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  String accessToken;

  _loadStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.accessToken = prefs.getString('access_token');
  }

  Future<List<Object>> search(String search) async {
    await _loadStorage();
    var response = await http.get(
      'https://api.myanimelist.net/v2/anime?q=' + search + '&limit=20',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
    var list = [];
    list.add(response.body);
    return list;
  }

  Widget _buildList(list) {
    Map<String, dynamic> listMap = jsonDecode(list);
    dynamic listMapData = listMap['data'];
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: new ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SearchCard(
                    title: listMapData[index]["node"]['title'],
                    image: listMapData[index]['node']['main_picture']['large'],
                  ),
                );
              },
              itemCount: listMapData.length,
            ),
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(
            searchBarStyle: SearchBarStyle(
              backgroundColor: kSecondaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            cancellationWidget: Text(
              'Cancel',
              style: TextStyle(color: kSecondaryColor),
            ),
            onSearch: search,
            onItemFound: (Object rep, int index) {
              return _buildList(rep);
            },
          ),
        ),
      ),
    );
  }
}
