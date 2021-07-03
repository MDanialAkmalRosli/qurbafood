import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _rememberMe = false;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController1 = new TextEditingController();
  TextEditingController _passwordController2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "QurbaFood",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.green),
                ),
                SizedBox(height: 5),
                Card(
                  margin: EdgeInsets.all(20),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Text(
                          'Registration for Newcomers',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email', icon: Icon(Icons.email)),
                        ),
                        TextField(
                          controller: _passwordController1,
                          decoration: InputDecoration(
                              labelText: 'Password', icon: Icon(Icons.lock)),
                          obscureText: true,
                        ),
                        TextField(
                          controller: _passwordController2,
                          decoration: InputDecoration(
                              labelText: 'Confirm your password', icon: Icon(Icons.lock_outline)),
                          obscureText: true,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: Colors.blue[700],
                                value: _rememberMe,
                                onChanged: (bool value) {
                                  _onChange(value);
                                }),
                            Text("Remember me"),
                          ],
                        ),
                        SizedBox(height: 5),
                        
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            minWidth: 100,
                            height: 50,
                            child: Text("Register",
                                style: TextStyle(color: Colors.white)),
                            onPressed: _onRegister,
                            color: Colors.blue[700]),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Text("Have an account? Login.",
                      style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
                  onTap: _loginUser,
                ),
                SizedBox(height: 7),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister() {
    String _email = _emailController.text.toString();
    String _password1 = _passwordController1.text.toString();
    String _password2 = _passwordController2.text.toString();

    if (_email.isEmpty || _password1.isEmpty || _password2.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email & password are empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    //this is where checking the data integrity
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Register new user"),
            content: Text("Are you sure?"),
            actions: [
              TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _registerUser(_email, _password1);
                  }),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _registerUser(String email, String password) {
    http.post(
        Uri.parse("https://crimsonwebs.com/s273046/qurbafood/php/register_user.php"),
        body: {"email": email, "password": password} ).then((response) {
      print(response.body);

      if(response.body == "SUCCESS"){
        Fluttertoast.showToast(
          msg: "Registration success! Check your email verification link!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      }
      else{
        Fluttertoast.showToast(
          msg: "Registration failed.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      }

    });
  }

  void _onChange(bool value) {
    print(value);
    setState(() {
      _rememberMe = value;
    });
  }

  void _loginUser() {
    Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  
}
