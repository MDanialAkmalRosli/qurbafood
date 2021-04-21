import 'package:flutter/material.dart';
import 'package:qurbafood/userattr.dart';
 
class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('QurbaFood'),
        ),
        body: Center(
          child: Container(
            child: Text('Selamat Datang!'),
          ),
        ),
      ),
    );
  }
}