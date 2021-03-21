import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './user-list.dart';

class SingleQuote extends StatelessWidget {
  SingleQuote({Key key, this.quoteUrl, this.image}) : super(key: key);
  final String quoteUrl;
  final String image;

  Future<dynamic> fetchData() async {
    var url = Uri.parse(this.quoteUrl);
    var result = await http.get(url);
    var quote = json.decode(result.body);
    print(quote);
    return quote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, new MaterialPageRoute(builder: (context) => UserList()));
        },
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
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
                  print(snapshot);
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(16.0),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage(this.image),
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(1), BlendMode.dstATop),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('"' + snapshot.data['content'] + '"',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.white,
                                fontSize: 55,
                              )),
                          Text(snapshot.data['author'],
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 35,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
