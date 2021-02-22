import 'package:flutter/material.dart';
import '../constants.dart';

class SearchCard extends StatelessWidget {
  final String title;
  final Function press;
  final Color color, textColor;
  final String image;

  const SearchCard({
    Key key,
    this.title,
    this.press,
    this.color = kSecondaryColor,
    this.textColor = Colors.black,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [ktmp, kSecondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: kSecondaryColor,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                )
              ]),
        ),
        Positioned.fill(
          child: Row(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              Image.network(
                this.image,
                height: 64,
                width: 64,
              ),
              Expanded(
                  child: Text(
                this.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                  fontFamily: 'Avenir',
                ),
                overflow: TextOverflow.fade,
                maxLines: 2,
              ))
            ],
          ),
        ),
      ],
    );
  }
}

class AnimeListCard extends StatelessWidget {
  final String title;
  final Function press;
  final Color color, textColor;
  final String image;

  const AnimeListCard({
    Key key,
    this.title,
    this.press,
    this.color = kSecondaryColor,
    this.textColor = Colors.black,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [ktmp, kSecondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: kSecondaryColor,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                )
              ]),
        ),
        Positioned.fill(
          child: Row(
            children: <Widget>[
              Image.network(
                this.image,
                height: 64,
                width: 64,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(
                          this.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: kPrimaryColor,
                            fontFamily: 'Avenir',
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: null,
                            elevation: 2.0,
                            fillColor: kSecondaryColor,
                            child: Icon(
                              Icons.add,
                              size: 30,
                            ),
                            padding: EdgeInsets.all(3.0),
                            shape: CircleBorder(),
                          ),
                          RawMaterialButton(
                            onPressed: null,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
