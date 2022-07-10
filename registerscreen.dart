import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'loginscreen.dart';
import 'package:ndialog/ndialog.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'models/config.dart';
import 'dart:async';
//import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isChecked = false;
  bool _passwordVisible = true;
  String eula = "";

  late double screenHeight, screenWidth, resWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();

  var _image;
  var pathAsset = "assets/images/camera.png";

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 150),
            child: Stack(
              children: [upperHalf(context), lowerHalf(context)],
            ),
          ),
        ),
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth,
        height: screenHeight / 2.5,
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              0.7,
            ],
            colors: [
              Colors.teal,
              Colors.indigo,
            ],
          )),
          child: GestureDetector(
              onTap: () => {_takePictureDialog()},
              child: SizedBox(
                  height: screenHeight / 2.0,
                  width: screenWidth / 4.0,
                  child: _image == null
                      ? Image.asset(pathAsset, scale: 4.5)
                      : Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ))),
        ),
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return SizedBox(
      height: 925,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 32),
              child: SizedBox(
                height: screenHeight / 1.25,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(-0.5, -0.6),
                      radius: 0.15,
                      colors: <Color>[
                        Color(0xFFEEEEEE),
                        Colors.black,
                      ],
                      stops: <double>[0.9, 1.0],
                    ),
                  ),
                  child: Card(
                    elevation: 35,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Register New Account",
                            style: TextStyle(
                              fontSize: resWidth * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "name must be longer than 3"
                                      : null,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              controller: _nameEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.person),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "enter a valid email"
                                  : null,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              controller: _emailEditingController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  labelStyle: TextStyle(),
                                  labelText: 'Email',
                                  icon: Icon(Icons.email),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || !val.contains("-")
                                      ? "enter a valid phone number"
                                      : null,
                              focusNode: focus1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus2);
                              },
                              controller: _phoneEditingController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  labelStyle: TextStyle(),
                                  labelText: 'Phone number',
                                  icon: Icon(Icons.phone),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 15)
                                      ? "enter a valid home address"
                                      : null,
                              focusNode: focus2,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus3);
                              },
                              controller: _addressEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Home address',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.home),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0),
                                  ))),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            validator: (val) =>
                                validatePassword(val.toString()),
                            focusNode: focus3,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus4);
                            },
                            controller: _passEditingController,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(),
                                labelText: 'Password',
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )),
                            obscureText: _passwordVisible,
                          ),
                          TextFormField(
                            style: const TextStyle(),
                            textInputAction: TextInputAction.done,
                            validator: (val) {
                              validatePassword(val.toString());
                              if (val != _passEditingController.text) {
                                return "password do not match";
                              } else {
                                return null;
                              }
                            },
                            focusNode: focus4,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus5);
                            },
                            controller: _pass2EditingController,
                            decoration: InputDecoration(
                                labelText: 'Re-enter Password',
                                labelStyle: const TextStyle(),
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                )),
                            obscureText: _passwordVisible,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: _showEULA,
                                  child: const Text('Agree with terms',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(screenWidth / 3, 50)),
                                child: const Text('Register',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                onPressed: _registerAccountDialog,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Already Register? ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )), ////
                              GestureDetector(
                                onTap: () => {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const LoginScreen()))
                                },
                                child: const Text(
                                  "Login here",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerAccountDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Registration Incomplete!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept the terms and conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUserAccount();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
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

  String? validatePassword(String value) {
    // String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
          ),
          content: SizedBox(
            height: screenHeight / 1.5,
            width: screenWidth,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;
    String _phone = _phoneEditingController.text;
    String _address = _addressEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());

    FocusScope.of(context).requestFocus(FocusNode());
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));

    progressDialog.show();

    http.post(Uri.parse(MyConfig.server + "/mynewtutor/php/register_user.php"),
        body: {
          "name": _name,
          "email": _email,
          "password": _pass,
          "phone": _phone,
          "address": _address,
          "image": base64Image
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Upload Image",
            ),
            content: TextButton.icon(
                onPressed: () => {
                      Navigator.of(context).pop(),
                      _galleryPicker(),
                    },
                icon: const Icon(Icons.browse_gallery),
                label: const Text("Gallery")));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
}
