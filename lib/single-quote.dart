import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './category.dart';

class SingleQuote extends StatefulWidget {
  @override
  _CSingleQuoteState createState() => _CSingleQuoteState();
}

class _CSingleQuoteState extends State<SingleQuote> {
  var tag = '';
  Future<dynamic> fetchData() async {
    var url = Uri.parse('https://api.quotable.io/random?tags=' + tag);
    var result = await http.get(url);
    var quote = json.decode(result.body);
    print(quote);
    return quote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.view_quilt),
            onPressed: () async {
              var returnedTag = await Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => Category()));
              if (returnedTag is String) {
                fetchData();
                tag = returnedTag;
                setState(() {
                  {}
                });
              }
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                {}
              });
            },
          )
        ],
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
                        image: NetworkImage(
                            "https://source.unsplash.com/random?" + tag),
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
