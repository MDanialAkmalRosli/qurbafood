import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:qurbafood/loadproducts.dart';
import 'package:qurbafood/userattr.dart';

class NewProduct extends StatefulWidget {
  final User userattr;

  const NewProduct({Key key, this.userattr}) : super(key: key);

  @override
  _NewProductState createState() => _NewProductState();
}

// Informations needed: Product name, Product type, Product price, Product qt,
class _NewProductState extends State<NewProduct> {
  TextEditingController _prnameCtrl = new TextEditingController();
  TextEditingController _prtypeCtrl = new TextEditingController();
  TextEditingController _prpriceCtrl = new TextEditingController();
  TextEditingController _prqtCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add New Products'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.local_grocery_store_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (content) => LoadProducts(userattr: widget.userattr)));
                // do something
              },
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.all(20),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Text(
                          'New product',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 10),

                        /* Enter product name */
                        TextField(
                          controller: _prnameCtrl,
                          decoration: InputDecoration(
                              labelText: 'Product name',
                              icon: Icon(Icons.pedal_bike_rounded)),
                        ),

                        /* Enter product type */
                        TextField(
                          controller: _prtypeCtrl,
                          decoration: InputDecoration(
                              labelText: 'Product type',
                              icon: Icon(Icons.grade_sharp)),
                        ),

                        /* Enter product price */
                        TextField(
                          controller: _prpriceCtrl,
                          decoration: InputDecoration(
                              labelText: 'Product price',
                              icon: Icon(Icons.attach_money_rounded)),
                        ),

                        /* Enter product quantity */
                        TextField(
                          controller: _prqtCtrl,
                          decoration: InputDecoration(
                              labelText: 'Product quantity',
                              icon: Icon(Icons.local_grocery_store_rounded)),
                        ),
                        SizedBox(height: 15),

                        /* Button to save the new product data */
                        MaterialButton(
                            minWidth: 200,
                            height: 50,
                            child: Text("Enter new product",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            onPressed: _onEnter,
                            color: Colors.green),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onEnter() {
    String _prname = _prnameCtrl.text.toString();
    String _prtype = _prtypeCtrl.text.toString();
    String _prprice = _prpriceCtrl.text.toString();
    String _prqty = _prqtCtrl.text.toString();

    if (_prname.isEmpty ||
        _prtype.isEmpty ||
        _prprice.isEmpty ||
        _prqty.isEmpty) {
      Fluttertoast.showToast(
          msg: "Some information is missing",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    http.post(
        Uri.parse(
            "http://crimsonwebs.com/s273046/qurbafood/php/new_product.php"),
        body: {
          "email": widget.userattr.email,
          "prname": _prname,
          "prtype": _prtype,
          "prprice": _prprice,
          "prqty": _prqty,
        }).then((response) {
      print(response.body);

      if (response.body == "You've success") {
        Fluttertoast.showToast(
            msg: "Input new product successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Input attempt failed...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
