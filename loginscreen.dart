import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:latesttutorapp/mainscreen.dart';
import 'package:latesttutorapp/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/config.dart';
import 'models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  bool remember = false;
  final focus = FocusNode();
  final focus1 = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
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
          child: Image.asset('assets/images/tutor.png', scale: 3),
        ),
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return SizedBox(
      height: 880,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 32),
              child: SizedBox(
                height: screenHeight / 1.8,
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
                      height: screenHeight,
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(),
                              prefixIcon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromARGB(255, 62, 59, 59)),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid email';
                              }
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);

                              if (!emailValid) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus);
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(),
                              prefixIcon: const Icon(Icons.lock),
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
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromARGB(255, 62, 59, 59)),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            focusNode: focus,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus1);
                            },
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: remember,
                                onChanged: (bool? value) {
                                  _onRememberMeChanged(value!);
                                },
                              ),
                              const Text("Remember Me",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16))
                            ],
                          ),
                          SizedBox(
                            width: screenWidth / 1.25,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: _loginUser,
                              child: const Text("User",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20)),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Sign up? ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: (() => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const RegisterScreen()))
                                    }),
                                child: const Text("Register here",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.indigo,
                                    )),
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

  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = _emailController.text;
      String password = _passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
        Fluttertoast.showToast(
            msg: "Preference Stored",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        _emailController.text = "";
        _passwordController.text = "";
        Fluttertoast.showToast(
            msg: "Preference Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Preference Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      remember = false;
    }
  }

  void _onRememberMeChanged(bool? value) {
    remember = value!;
    setState(() {
      if (remember) {
        _saveRemovePref(true);
      } else {
        _saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        remember = true;
      });
    }
  }

  void _loginUser() {
    String _email = _emailController.text;
    String _password = _passwordController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      http.post(Uri.parse(MyConfig.server + "/mynewtutor/php/login_user.php"),
          body: {"email": _email, "password": _password}).then((response) {
        var data = jsonDecode(response.body);
        print(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          User user = User.fromJson(data['data']);
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => MainScreen(
                        user: user,
                      )));
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      });
    }
  }
}