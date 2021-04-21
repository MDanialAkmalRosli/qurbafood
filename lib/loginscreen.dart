import 'package:flutter/material.dart';
import 'mainscreen.dart';
import 'registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'userattr.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  SharedPreferences prefs;

  @override
  void initState() {
    loadPreference();
    super.initState();
  }

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
                SizedBox(height: 20),
                Card(
                  margin: EdgeInsets.all(20),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email', icon: Icon(Icons.email)),
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              labelText: 'Password', icon: Icon(Icons.lock)),
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.green,
                                value: _rememberMe,
                                onChanged: (bool value) {
                                  _onChange(value);
                                }),
                            Text("Remember me"),
                          ],
                        ),
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minWidth: 100,
                            height: 50,
                            child: Text("Login",
                                style: TextStyle(color: Colors.white)),
                            onPressed: _onLogin,
                            color: Colors.green),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Text("No account? Register.",
                      style: TextStyle(fontSize: 16)),
                  onTap: _registerNewUser,
                ),
                SizedBox(height: 7),
                GestureDetector(
                  child:
                      Text("Forgot password?", style: TextStyle(fontSize: 16)),
                  onTap: _forgetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s273046/qurbafood/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) {
      print(response.body);
      if (response.body == "failed") {
        print("Login Failed...");
      } else {
        List userdata = response.body.split(",");
        User user = User(
            email: _email,
            password: _password,
            datereg: userdata[1],
            );
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user)));
      }
    });
  }

  void _onChange(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
      print("Email & password are empty!");
      return;
    }
    setState(() {
      _rememberMe = value;
      storePref(value, _email, _password);
    });
  }

  void _registerNewUser() {
    Navigator.push(
            context, MaterialPageRoute(builder: (content) => RegistrationScreen()));
  }

  void _forgetPassword() {
    TextEditingController _useremailcontroller = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Forgot your Password?"),
            content: new Container(
                height: 80,
                child: Column(
                  children: [
                    Text("Enter recovery email"),
                    TextField(
                      controller: _useremailcontroller,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                    )
                  ],
                )),
            actions: [
              TextButton(
                child: Text("Submit"),
                onPressed: () {
                  print(_useremailcontroller.text);
                  _resetPassword(_useremailcontroller.text);
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

  void _resetPassword(String emailreset) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s273046/qurbafood/php/reset_user.php"),
        body: {"email": emailreset}).then((response) {
      print(response.body);
      if (response.body == "success") {
        print("Check your email");
      } else {
        print("Failed");
      }
    });
  }

    Future<void> storePref(bool value, String email, String password) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      print("Your preferences are stored");
      return;
    } else {
      await prefs.setString("email", '');
      await prefs.setString("password", '');
      await prefs.setBool("rememberme", value);
      print("Your preferences are deleted");
      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
        _rememberMe = false;
      });
      return;
    }
  }

  Future<void> loadPreference() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';
    _rememberMe = prefs.getBool("rememberme") ?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }



}
