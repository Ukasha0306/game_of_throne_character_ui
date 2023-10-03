import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_of_throne_character_ui/model/got_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class GotPage extends StatefulWidget {
  const GotPage({Key? key}) : super(key: key);

  @override
  State<GotPage> createState() => _GotPageState();
}

Color mainColor = Colors.amber;
Color secColor = Colors.black;

class _GotPageState extends State<GotPage> {
  final List<GotModel> _gotList = [];

  Future<List<GotModel>> getAPi() async {
    final response =
        await http.get(Uri.parse("https://thronesapi.com/api/v2/Characters"));
    var data = jsonDecode(response.body.toString());
    setState(() {});
    print(response.body);

    if (response.statusCode == 200) {
      for (Map i in data) {
        _gotList.add(GotModel.fromJson(i as Map<String, dynamic>));
      }
      return _gotList;
    } else {
      return _gotList;
    }
  }

  showGridViewWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _gotList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                 fit: StackFit.expand,
                children: [
                  Image.network(
                    _gotList[index].imageUrl.toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, value, child) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                      );
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          _gotList[index].firstName.toString().isNotEmpty
                              ? _gotList[index].firstName.toString()
                              : _gotList[index].lastName.toString(),
                          style: GoogleFonts.pacifico(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width > 800
                                  ? 50
                                  : 25,
                            ),
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          _gotList[index].family.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          _gotList[index].id.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }

  @override
  var response;

  void initState() {
    getAPi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Center(
            child: Text("Got 2019",
                style: GoogleFonts.actor(
                  fontSize: MediaQuery.of(context).size.width > 800 ? 1 : .35,
                ))),
        elevation: 0,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        20.ph,
        Center(
          child: CircleAvatar(
              radius: MediaQuery.of(context).size.width > 600 ? 150 : 70,
              backgroundImage: const AssetImage('assets/images/download.jpeg')),
        ),
        12.ph,
        Text(
          "Game of Throne",
          style: GoogleFonts.pacifico(
            textStyle: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        20.ph,
        Expanded(child: showGridViewWidget()),
      ]),
    );
  }
}

extension PaddingExtension on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );

  SizedBox get pw => SizedBox(
        width: toDouble(),
      );
}
