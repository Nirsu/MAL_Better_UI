import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/constants.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  TabController _tabController;
  String accessToken;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  _loadStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.accessToken = prefs.getString('access_token');
  }

  Widget _buildListTile(animeInfo) {
    return ListTile(
      leading: new Image.network(animeInfo['node']['main_picture']['large']),
      title: new Text(animeInfo['node']['title']),
      onTap: () => {},
    );
  }

  Widget _buildList(list) {
    Map<String, dynamic> listMap = jsonDecode(list.body);
    dynamic listMapData = listMap['data'];
    return listMapData != null ? ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: _buildListTile(listMapData[index]),
        );
      },
      itemCount: listMapData.length,
    ) : Center(
      child: Text('ERROR : Failed to get anime list', style: TextStyle(color: kSecondaryColor),)
    );
  }

  Future<http.Response> getListAnime() async {
    await _loadStorage();
    var response = http.get(
      'https://api.myanimelist.net/v2/users/@me/animelist?status=watching&limit=20',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
    return response;
  }

  Future<http.Response> getListManga() async {
    await _loadStorage();
    return http.get(
      'https://api.myanimelist.net/v2/users/@me/mangalist?status=reading&limit=20',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
  }

  Widget printList(function) {
    return Scaffold (
      body: FutureBuilder (
        future: function,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return _buildList(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget getTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: kSecondaryColor,
      labelColor: kSecondaryColor,
      unselectedLabelColor: Colors.white,
      tabs: [
        Tab(
          child: Center(
            child: Text('Anime'),
          ),
        ),
        Tab(
          child: Center(
            child: Text('Manga'),
          ),
        )
      ],
    );
  }

  Widget getTabBarPages() {
    return TabBarView(
      controller: _tabController,
      children: [
        this.printList(this.getListAnime()),
        this.printList(this.getListManga()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        flexibleSpace: SafeArea(
          child: getTabBar(),
        ),
      ),
      body: getTabBarPages()
    );
  }
}