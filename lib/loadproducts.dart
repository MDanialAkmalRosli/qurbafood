import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qurbafood/checkoutscreen.dart';
import 'package:qurbafood/userattr.dart';

class LoadProducts extends StatefulWidget {
  final User userattr;
  final String email;
  const LoadProducts({Key key, this.email, this.userattr}) : super(key: key);

  @override
  _LoadProductsState createState() => _LoadProductsState();
}

class _LoadProductsState extends State<LoadProducts> {
  double screenHeight, screenWidth;
  List prodlist = [];
  String itemcenter = "Loading...";
  String title, prname;
  double totalprice = 0.0;

  TextEditingController _searchCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts(_searchCtrl.text);
    _searchProd(_searchCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cart List'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [

                TextFormField(
                  controller: _searchCtrl,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Look for products?",
                    suffixIcon: IconButton(
                      onPressed: () => _searchProd(_searchCtrl.text),         
                      icon: Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),

                prodlist == null
                    ? Flexible(child: Center(child: Text(itemcenter)))
                    : Flexible(
                        child: Center(
                            child: GridView.count(
                                crossAxisCount: 1,
                                childAspectRatio:
                                    (screenWidth / screenHeight) / 0.3,
                                children:
                                    List.generate(prodlist.length, (index) {
                                  return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Card(
                                      child: Column(
                                        children: [                                      
                                          SizedBox(height: 10),
                                          Text(
                                            prodlist[index]['prname'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(prodlist[index]['prtype']),
                                          SizedBox(height: 5),
                                          Text("Price: " +
                                              prodlist[index]['prprice']),
                                          SizedBox(height: 5),
                                          Text("Quantity: " +
                                              prodlist[index]['prqty']),
                                          SizedBox(height: 10),
                                          Text(
                                            "Cost per product: RM " +
                                                (int.parse(prodlist[index]
                                                            ['prqty']) *
                                                        double.parse(
                                                            prodlist[index]
                                                                ['prprice']))
                                                    .toStringAsFixed(2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })))),
                SizedBox(height: 1),
                Divider(
                  color: Colors.green,
                  thickness: 3,
                ),
                Text(
                  "TOTAL COST: RM " + totalprice.toStringAsFixed(2),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.green,
                  thickness: 3,
                ),
                MaterialButton(
                    minWidth: 100,
                    height: 30,
                    child: Text("Checkout",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen(email: widget.userattr.email, total: totalprice,)));
                    },
                    color: Colors.blue[800]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadProducts(String text) {
    http.post(
        Uri.parse("http://crimsonwebs.com/s273046/qurbafood/php/load_product.php"),
        body: {"email": widget.userattr.email,}).then((response) {
      if (response.body == "no data") {
        itemcenter = "No items to display. Sorry.";
        return;
      } else {
        var jsondata = json.decode(response.body);
        prodlist = jsondata["products"];

        for (int i = 0; i < prodlist.length; i++) {
          totalprice = totalprice +
              double.parse(prodlist[i]['prprice']) *
                  int.parse(prodlist[i]['prqty']);
        }

        setState(() {});
        print(response.body);
      }
    });
  }

  // belum selesai lagi
  void _searchProd(String text) {
    String komen = "";
    http.post(
        Uri.parse("http://crimsonwebs.com/s273046/qurbafood/php/search_product.php"),
        body: {"prname": text,}).then((response) {
      if (response.body == "no data") {
        itemcenter = "No items to display. Sorry.";
        prodlist = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        prodlist = jsondata["products"];
        komen = "There are items in the product list.";
      }
      setState(() {});
      print(komen);
    });
  }

}
