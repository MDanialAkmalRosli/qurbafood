import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qurbafood/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User2 user;

  const PaymentScreen({Key key, this.user}) : super(key: key);
  
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Payment Section'),
          centerTitle: true,
          backgroundColor: Colors.deepOrange[500],
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: WebView(
                    initialUrl:
                        'https://crimsonwebs.com/s273046/qurbafood/php/generate_bill.php?email=' + widget.user.email +
                            '&mobile=' + widget.user.phone +
                            '&name=' + widget.user.name +
                            '&amount=' + widget.user.amount,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      controller.complete(webViewController);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
