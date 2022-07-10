import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latesttutorapp/models/config.dart';
import 'package:latesttutorapp/models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final double totalpayable;

  const PaymentScreen(
      {Key? key, required this.user, required this.totalpayable})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: MyConfig.server +
                    '/mynewtutor/php/payment.php?email=' +
                    widget.user.email.toString() +
                    '&mobile=' +
                    widget.user.phone.toString() +
                    '&name=' +
                    widget.user.name.toString() +
                    '&amount=' +
                    widget.totalpayable.toString(),
                    
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  print('Loading (progress : $progress%)');
                },
                onPageFinished: (String initialUrl) {
                  print('Finish loading: $initialUrl');
                  print(widget.user.email.toString());
                  print( widget.user.phone.toString());
                  print(widget.user.name.toString());
                  print(widget.totalpayable.toString());
                },
              ),
            )
          ],
        ));
  }
}
