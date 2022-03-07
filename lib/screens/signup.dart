import 'package:flutter/material.dart';
import 'package:subka_bazaar/helper/textInputDesign.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
                    decoration:
                        buildInputDecoration(Icons.person, "First Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value ?? "";
                    },
                  ),
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
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration(Icons.person, "Last Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value ?? "";
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
                        return 'Please a Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: confirmpassword,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration:
                        buildInputDecoration(Icons.lock, "Confirm Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter password';
                      }
                      if (password.text != confirmpassword.text) {
                        return "Password does not match";
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
                      }
                    },
                    child: const Text("Submit"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
