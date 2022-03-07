import 'package:flutter/material.dart';
import 'package:subka_bazaar/screens/home.dart';
import 'package:subka_bazaar/screens/signup.dart';
import 'package:subka_bazaar/helper/textInputDesign.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  late String name, email, phone;

  //TextController to read text entered in text field
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset('asset/images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.email, "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value ?? "";
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: buildInputDecoration(Icons.lock, "Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      if (value.length < 6) {
                        return 'Minimum length 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState?.save();
                        // use the email provided here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    },
                    child: const Text("Sign In")),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: const Text("Sign Up"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
