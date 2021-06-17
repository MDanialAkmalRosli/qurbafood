import 'package:flutter/material.dart';
 
void main() => runApp(PaymentScreen());
 
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
            child: Text('Pay here'),
          ),
        ),
      ),
    );
  }
}