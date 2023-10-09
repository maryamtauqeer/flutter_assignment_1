import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment_1/bottomSheet.dart';
import 'package:flutter_assignment_1/model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Comments',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 107, 209, 244),
        ),
        body: Center(
            child: FutureBuilder<List<Comments>>(
                future: fetchComments(),
                builder: (context, snapshot) {
                  // print(snapshot.hasData);
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (contxt, i) {
                        var item = snapshot.data![i];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              // isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Container(
                                          color: Colors.white,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child:
                                              BottomSheetWidget(comment: item),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: commentListItem(item),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  }

                  return const CircularProgressIndicator(
                      color: Color.fromARGB(255, 107, 209, 244));
                })));
  }

  Widget commentListItem(Comments obj) {
    return Card(
        child: ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(8.0), // Adjust the border radius as needed
      ),
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 107, 209, 244),
        child: Text(obj.id.toString()),
      ),
      title: Text(obj.name),
      contentPadding: const EdgeInsets.all(15.0),
    ));
  }
}

Future<List<Comments>> fetchComments() async {
  try {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    if (response.statusCode == 200) {
      List<dynamic> _parsedListJson = jsonDecode(response.body);
      List<Comments> _itemsList =
          _parsedListJson.map((json) => Comments.fromJson(json)).toList();
      return _itemsList;
    } else {
      throw Exception('Failed to load Comments: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching comments: $error');
    throw Exception('Failed to load Comments');
  }
}
