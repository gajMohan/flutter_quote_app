import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SingleQuote extends StatelessWidget {
  SingleQuote({Key key, this.quote, this.image, this.author}) : super(key: key);
  final String quote;
  final String image;
  final String author;

  Future<List<dynamic>> fetchData() async {
    var url = Uri.parse(this.author);
    var result = await http.get(url);
    return json.decode(result.body)['results'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                          Text('"' + this.quote + '"',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.white,
                                fontSize: 55,
                              )),
                          Text(this.author,
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
