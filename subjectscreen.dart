import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latesttutorapp/cartscreen.dart';
import 'package:latesttutorapp/models/config.dart';
import 'package:latesttutorapp/models/subject.dart';
import 'package:http/http.dart' as http;

import 'models/user.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var _tapPosition;
  var numofpage, curpage = 1;
  var color;

  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadSubjects(1, search);
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
      body: subjectList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            )
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _loadSearchDialog();
                      },
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) => CartScreen(
                                      user: widget.user,
                                    )));
                        _loadSubjects(1, search);
                        _loadMyCart();
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                      ),
                      label: Text(widget.user.cart.toString(),
                          style: const TextStyle()),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: 0.88,
                      children: List.generate(subjectList.length, (index) {
                        return InkWell(
                          splashColor: Colors.red[200],
                          onTap: () => {_loadSubjectDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: MyConfig.server +
                                      "/mynewtutor/assets/courses/" +
                                      subjectList[index].subjectId.toString() +
                                      '.PNG',
                                  fit: BoxFit.cover,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                            subjectList[index]
                                                .subjectName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        Text(
                                            "RM" +
                                                double.parse(subjectList[index]
                                                        .subjectPrice
                                                        .toString())
                                                    .toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 5),
                                        Text(
                                            subjectList[index]
                                                    .subjectSessions
                                                    .toString() +
                                                " sessions",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 25, 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                    subjectList[index]
                                                        .subjectRating
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                IconButton(
                                                  icon: const Icon(Icons.star),
                                                  color: Colors.red,
                                                  onPressed: () {},
                                                ),
                                                Expanded(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          _addtocartDialog(
                                                              index);
                                                        },
                                                        icon: const Icon(Icons
                                                            .shopping_cart)),
                                                  ],
                                                )),
                                              ]),
                                        ),
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
                          onPressed: () => {_loadSubjects(index + 1, "")},
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

  _loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    print(search);
    http.post(Uri.parse(MyConfig.server + "/mynewtutor/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
          //'type': _type,
        }).timeout(
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

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
          setState(() {});
        }
      }
    });
  }

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: Colors.cyan[100],
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle: const TextStyle(fontSize: 16),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                search = searchController.text;
                                print(search);
                                Navigator.of(context).pop();
                                _loadSubjects(1, search);
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      print(search);
                      Navigator.of(context).pop();
                      _loadSubjects(1, search);
                    },
                    child: const Text("Search",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  )
                ],
              );
            },
          );
        });
  }

  void _loadMyCart() {
    http.post(Uri.parse(MyConfig.server + "/mynewtutor/php/load_mycartqty.php"),
        body: {
          "email": widget.user.email.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
      }
    });
  }

  void _addtoCart(int index) {
    http.post(Uri.parse(MyConfig.server + "/mynewtutor/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "sjid": subjectList[index].subjectId.toString(), //edit-done
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString()); //edit
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _addtocartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Add this subject",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addtoCart(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _loadSubjectDetails(int index) {
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
                      "/mynewtutor/assets/courses/" +
                      subjectList[index].subjectId.toString() +
                      '.PNG',
                  fit: BoxFit.fitHeight,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10),
                Card(
                    elevation: 10,
                    child: Container(
                      color: Colors.cyan[200],
                      child: Column(
                        children: [
                          Text(subjectList[index].subjectName.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(10),
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
                                              subjectList[index]
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
                                                  double.parse(
                                                          subjectList[index]
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
                                              subjectList[index]
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
                                              subjectList[index]
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
