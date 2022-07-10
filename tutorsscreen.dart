import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latesttutorapp/models/config.dart';
import 'package:latesttutorapp/models/subject.dart';
import 'package:latesttutorapp/models/tutor.dart';
import 'package:http/http.dart' as http;

class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutor> tutorList = <Tutor>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      body: tutorList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            )
          : Column(children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Tutors available",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (0.88),
                      children: List.generate(tutorList.length, (index) {
                        return InkWell(
                          splashColor: Colors.red[200],
                          onTap: () => {_loadTutorDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: MyConfig.server +
                                      "/mynewtutor/assets/tutors/" +
                                      tutorList[index].tutorId.toString() +
                                      '.jpg', //change path
                                  fit: BoxFit.fitHeight,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Text(
                                            tutorList[index]
                                                .tutorName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        Text(
                                            tutorList[index]
                                                .tutorPhone
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        Text(
                                            tutorList[index]
                                                .tutorEmail
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ))
                            ],
                          )),
                        );
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadTutors(index + 1)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(MyConfig.server + "/mynewtutor/php/load_tutors.php"),
        body: {'pageno': pageno.toString()}).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
          setState(() {});
        }
      }
    });
  }

  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: MyConfig.server +
                      "/mynewtutor/assets/tutors/" +
                      tutorList[index].tutorId.toString() +
                      '.jpg',
                  fit: BoxFit.fitHeight,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10),
                Column(children: [
                  Text(tutorList[index].tutorName.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(tutorList[index].tutorPhone.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(tutorList[index].tutorEmail.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 10),
                  Text(tutorList[index].tutorDescription.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500)),
                ]),
                const SizedBox(height: 20),
                Card(
                    elevation: 10,
                    child: Container(
                      color: Colors.cyan[200],
                      child: Column(
                        children: [
                          Text(tutorList[index].subjectName.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, left: 0, right: 0, bottom: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(20),
                                  child: Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(7),
                                    },
                                    defaultColumnWidth:
                                        const FixedColumnWidth(120.0),
                                    border: TableBorder.all(
                                        style: BorderStyle.none),
                                    children: [
                                      TableRow(children: [
                                        Column(children: const [
                                          Text('Subject ID',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(height: 5),
                                        ]),
                                        Column(children: [
                                          Text(
                                              tutorList[index]
                                                  .subjectId
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5),
                                        ]),
                                      ]),
                                      TableRow(children: [
                                        Column(children: const [
                                          Text('Subject Price',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(height: 5),
                                        ]),
                                        Column(children: [
                                          Text(
                                              "RM" +
                                                  double.parse(tutorList[index]
                                                          .subjectPrice
                                                          .toString())
                                                      .toStringAsFixed(2),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5),
                                        ]),
                                      ]),
                                      TableRow(children: [
                                        Column(children: const [
                                          Text('Subject Session',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(height: 5)
                                        ]),
                                        Column(children: [
                                          Text(
                                              tutorList[index]
                                                  .subjectSessions
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5)
                                        ]),
                                      ]),
                                      TableRow(children: [
                                        Column(children: const [
                                          Text('Subject Rating',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ))
                                        ]),
                                        Column(children: [
                                          Text(
                                              tutorList[index]
                                                  .subjectRating
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 10),
                  Text(tutorList[index].subjectDescription.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500)),
                ]),
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
