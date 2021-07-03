import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:qurbafood/delivery_class.dart';
import 'package:qurbafood/paymentscreen.dart';
import 'package:qurbafood/mappage.dart';
import 'package:qurbafood/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  final String email;
  final double total;

  const CheckoutScreen({Key key, this.email, this.total}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String name = "Enter your name";
  String phno = "Enter your phone number";
  String address = "";

  int _radioValue = 0;
  String delivmethod = "Pickup";
  bool deliv = false;
  bool pkup = true;

  TextEditingController _locationcontroller = new TextEditingController();
  String curtime = " ";
  String initial_time = "10:00";
  Position currentPosition;
  SharedPreferences prefs;

  get user => null;

  @override
  void initState() {
    super.initState();
    final now = new DateTime.now();
    curtime = DateFormat("Hm").format(now);
    int cmin = convertMin(curtime);
    initial_time = minToTime(cmin);
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    String date_today = DateFormat('dd/MM/yyyy HH:mm').format(now);

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Payment Checkout'),
        ),
        body: Column(
          children: [
            Container(
              child: Image.asset('assets/images/pay.jpg'),
            ),
            SizedBox(height: 3),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            Expanded(
              flex: 10,
              child: ListView(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          // text
                          Text(
                            "CUSTOMER DETAILS",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          // name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(flex: 3, child: Text("Name:")),
                              Container(
                                  height: 20,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                flex: 7,
                                child: GestureDetector(
                                    onTap: () => {nameDialog()},
                                    child: Text(name)),
                              )
                            ],
                          ),
                          // email
                          Row(
                            children: [
                              Expanded(flex: 3, child: Text("Email:")),
                              Container(
                                  height: 20,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                flex: 7,
                                child: Text(widget.email),
                              )
                            ],
                          ),
                          // phone no.
                          Row(
                            children: [
                              Expanded(flex: 3, child: Text("Phone no.:")),
                              Container(
                                  height: 20,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                flex: 7,
                                child: GestureDetector(
                                    onTap: () => {phnoDialog()},
                                    child: Text(phno)),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(
                            height: 2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: [
                          // delivery method
                          Text(
                            "DELIVERY METHOD",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Pickup"),
                              new Radio(
                                value: 0,
                                groupValue: _radioValue,
                                onChanged: (int value) {
                                  _handleRadioValueChanged(value);
                                },
                              ),
                              Text("Delivery"),
                              new Radio(
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: (int value) {
                                  _handleRadioValueChanged(value);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Visibility(
                    visible: pkup,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Column(
                          children: [
                            Text(
                              "Pickup Time",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              margin: EdgeInsets.all(3),
                              width: 300,
                              child: Text(
                                  "Pickup time daily from 1000 hrs to 2000 hrs from our store. Allow us 20 minutes to prepare your order before pickup time."),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: Text("Current time: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                  flex: 7,
                                  child: Text(date_today),
                                )
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: Text("Set pickup time:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(initial_time + "\t\t\t\t\t\t"),
                                        MaterialButton(
                                            minWidth: 70,
                                            height: 30,
                                            child: Text("Select",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () {
                                              _choose_time(context);
                                            },
                                            color: Colors.blue[600]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), // end of pickup part

                  Visibility(
                    visible: deliv,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Column(
                          children: [
                            Text(
                              "Delivery Address",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _locationcontroller,
                                        style: TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Search / Enter address'),
                                        keyboardType: TextInputType.multiline,
                                        minLines: 5, // Size of TextField
                                        maxLines:
                                            5, // when user presses enter it will adapt to it
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 100,
                                  child: MaterialButton(
                                    child: Text("Location",
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () => {_getUserLocation()},
                                    color: Colors.green,
                                  ),
                                ),
                                Container(
                                  width: 125,
                                  child: MaterialButton(
                                    child: Text("Access Map",
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () async {
                                      Delivery _delivery =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MapPage(),
                                        ),
                                      );
                                      print(address);
                                      setState(() {
                                        _locationcontroller.text =
                                            _delivery.address;
                                      });
                                    },
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: [
                          Text(
                            "TOTAL AMOUNT: RM" +
                                widget.total.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange[500],
                            ),
                          ),
                          MaterialButton(
                              minWidth: 100,
                              height: 30,
                              child: Text("Make a Payment",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                /*
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => PaymentScreen()));
                                print("Pay now");*/
                                _makePayment();
                              },
                              color: Colors.deepOrange[500]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRadioValueChanged(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          delivmethod = "Pickup";
          deliv = false;
          pkup = true;
          break;

        case 1:
          delivmethod = "Delivery";
          deliv = true;
          pkup = false;
          break;
      }

      print(delivmethod);
    });
  }

  Future<Null> _choose_time(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
    final now = new DateTime.now();
    print("Current time: " + now.toString());

    String yy = DateFormat('y').format(now);
    String mm = DateFormat('M').format(now);
    String dd = DateFormat('d').format(now);

    String hr, min, time = " ";

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        hr = selectedTime.hour.toString();
        min = selectedTime.minute.toString();
        time = hr + ':' + min;
        initial_time = time;
        curtime = DateFormat("Hm").format(now);

        initial_time = formatDate(
            DateTime(int.parse(yy), int.parse(mm), int.parse(dd),
                selectedTime.hour, selectedTime.minute),
            [HH, ':', nn, " "]).toString();

        int ct = convertMin(curtime);
        int st = convertMin(time);
        int time_diff = st - ct;

        if (time_diff < 20) {
          Fluttertoast.showToast(
              msg: "The time you choose is too short.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.deepOrange[500],
              textColor: Colors.white,
              fontSize: 16.0);
          initial_time = minToTime(ct);
          setState(() {});
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Pickup time updated.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name") ?? 'Enter your name';
    phno = prefs.getString("phone") ?? 'Enter your phone number';
    setState(() {});
  }

  void setPickupExt() {
    final now = new DateTime.now();
    curtime = DateFormat("Hm").format(now);
    int cm = convertMin(curtime);
    initial_time = minToTime(cm);
    setState(() {});
  }

  String minToTime(int min) {
    var m = min + 20;
    var d = Duration(minutes: m);
    List<String> parts = d.toString().split(':');
    String tm = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    return DateFormat.jm().format(DateFormat("hh:mm").parse(tm));
  }

  int convertMin(String time) {
    var val = time.split(":");
    int h = int.parse(val[0]);
    int m = int.parse(val[1]);
    int to_min = (h * 60) + m;
    return to_min;
  }

  void nameDialog() {
    TextEditingController _namecontroller = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter your name"),
            content: new Container(
                height: 50,
                child: Column(
                  children: [
                    TextField(
                      controller: _namecontroller,
                    )
                  ],
                )),
            actions: [
              TextButton(
                child: Text("Proceed"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  name = _namecontroller.text;
                  prefs = await SharedPreferences.getInstance();
                  await prefs.setString("name", name);
                  setState(() {});
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void phnoDialog() {
    TextEditingController _phnocontroller = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter your phone no."),
            content: new Container(
                height: 50,
                child: Column(
                  children: [
                    TextField(
                      controller: _phnocontroller,
                    )
                  ],
                )),
            actions: [
              TextButton(
                child: Text("Proceed"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  phno = _phnocontroller.text;
                  prefs = await SharedPreferences.getInstance();
                  await prefs.setString("phone", phno);
                  setState(() {});
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  _getUserLocation() async {
    ProgressDialog pd = ProgressDialog(context,
        title: Text("Locating the address"), message: Text("Searching..."));
    pd.show();
    await _determinePosition().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
    pd.dismiss();
  }

  void _getPlace(Position p) async {
    List<Placemark> newLocation =
        await placemarkFromCoordinates(p.latitude, p.longitude);

    // all required informations about location
    Placemark placeMark = newLocation[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = name +
        ", " +
        subLocality +
        ", \n" +
        postalCode +
        ", " +
        locality +
        ", \n" +
        administrativeArea +
        ", " +
        country;
    _locationcontroller.text = address;
    print("Delivery address updated");
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _makePayment() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pay RM" + widget.total.toStringAsFixed(2) + "?",
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: <Widget>[
              TextButton(
                child: Text("Proceed"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  User2 _user = new User2(
                      widget.email, phno, name, widget.total.toString());
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(user: _user),
                    ),
                  );
                },
              ),
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
