import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  TabController _tabController;

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

  Widget getTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.black,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.white,
      tabs: [
        Tab(
          text: "Anime",
        ),
        Tab(
          text: 'Manga',
        )
      ],
    );
  }

  Widget getTabBarPages() {
    return TabBarView(
      controller: _tabController,
      children: [
        Center(
          child: Text('A for Anime'),
        ),
        Center(
          child: Text('M for Manga'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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