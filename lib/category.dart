import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Category extends StatelessWidget {
  Category({Key key, this.quoteUrl, this.image}) : super(key: key);
  final String quoteUrl;
  final String image;

  Future<List<dynamic>> fetchData() async {
    var url = Uri.parse('https://api.quotable.io/tags');
    var result = await http.get(url);
    var quote = json.decode(result.body);
    print(quote);
    return quote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Categories",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: FutureBuilder<List<dynamic>>(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Press button to start');
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else {
                  final children = <Widget>[];
                  //The idea is i want alternating columns of categories
                  //One with two and the next with one then repeat
                  //Very ugly but works
                  for (int i = 0; i < snapshot.data.length; i++) {
                    if (i % 3 == 0) {
                      if ((i + 1) < snapshot.data.length) {
                        children.add(
                            customTile(snapshot.data[i], snapshot.data[i + 1]));
                        i++;
                      } else {
                        children.add(customTile(snapshot.data[i]));
                      }
                    } else {
                      children.add(customTile(snapshot.data[i]));
                    }
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: children,
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget tile(tag, alignment) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
          onTap: () {
            Navigator.pop(context, tag['name']);
          },
          child: Container(
            width: 300,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: alignment,
              children: <Widget>[
                Image(
                  width: 200,
                  image: NetworkImage(
                      'https://source.unsplash.com/random?' + tag['name']),
                ),
                Text(tag['name'],
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontStyle: FontStyle.italic,
                        fontSize: 35,
                        color: Theme.of(context).accentColor))
              ],
            ),
          ));
    });
  }

  Widget customTile(tag1, [tag2]) {
    final tiles = <Widget>[];

    if (tag2 == null) {
      tiles.add(tile(tag1, CrossAxisAlignment.center));
    } else {
      tiles.add(tile(tag1, CrossAxisAlignment.end));
      tiles.add(tile(tag2, CrossAxisAlignment.start));
    }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: tiles,
        ),
      );
    });
  }
}
