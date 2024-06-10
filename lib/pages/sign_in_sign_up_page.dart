import 'package:scoped_model/scoped_model.dart';
import '../models/connected_scope_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/state.dart';

class auth_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _auth_page();
  }
}

class _auth_page extends State<auth_page> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final _email = TextEditingController();
  final password = TextEditingController();
  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final date_of_birth = TextEditingController();
  final phone_number = TextEditingController();
  bool accept_term = false;
  Auth_model model = Auth_model();
  switch_between_login_and_signup state =
      switch_between_login_and_signup.Signin;
  @override
  build(BuildContext context) {
    double device_width = MediaQuery.of(context).size.width;
    double target =
        device_width > 550 ? 500 : MediaQuery.of(context).size.width * 0.95;
    // TODO: implement build
    return ScopedModelDescendant<Auth_model>(
      builder: (context, child, model) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
              onTap: () {
                return FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("photo.jpg"),
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.dstATop),
                          fit: BoxFit.cover)),
                  padding: EdgeInsets.all(10.0),
                  child: Form(
                      key: key,
                      child: Center(
                          child: SingleChildScrollView(
                              child: Column(
                        children: [
                          state == switch_between_login_and_signup.Signin
                              ? Center()
                              : TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: first_name,
                                  decoration: InputDecoration(
                                      labelText: "first name",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 25.0))),
                                  onSaved: (value) {
                                    first_name.text = value.trim();
                                  },
                                  validator: (value) {
                                    value = value.trim();
                                    if (value.isEmpty ||
                                        !RegExp(r"^[a-zA-Z ]{2,30}$")
                                            .hasMatch(value)) {
                                      return "enter valid name";
                                    }
                                  },
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                          state == switch_between_login_and_signup.Signin
                              ? Center()
                              : TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: last_name,
                                  decoration: InputDecoration(
                                      labelText: "last name",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 25.0))),
                                  onSaved: (newValue) {
                                    last_name.text = newValue.trim();
                                  },
                                  validator: (value) {
                                    value = value.trim();
                                    if (value.isEmpty ||
                                        !RegExp(r"^[a-zA-Z ]{2,30}$")
                                            .hasMatch(value)) {
                                      return "enter valid name";
                                    }
                                  }),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _email,
                            decoration: InputDecoration(
                                labelText: "email",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 25.0))),
                            validator: (value) {
                              value = value.trim();
                              if (value.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                                      .hasMatch(value)) {
                                return "you must put vaild email";
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: password,
                            decoration: InputDecoration(
                                labelText: "password",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 25.0))),
                            /* onSaved: (newValue) {
                              password.text = newValue.trim();
                            },*/
                            validator: (value) {
                              value = value.trim();
                              if (value.isEmpty ||
                                  !RegExp(r"^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})")
                                      .hasMatch(value))
                                return "you must enter valid password";
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          state == switch_between_login_and_signup.Signin
                              ? Center()
                              : TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: date_of_birth,
                                  decoration: InputDecoration(
                                      labelText: "date of birth",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 25.0))),
                                  onSaved: (value) {
                                    date_of_birth.text =
                                        value.trim().toString();
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "please enter your date of birth";
                                    }
                                  },
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                          state == switch_between_login_and_signup.Signin
                              ? Center()
                              : TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: phone_number,
                                  decoration: InputDecoration(
                                      labelText: "phone number",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 25.0))),
                                  onSaved: (newValue) {
                                    phone_number.text = newValue.trim();
                                  },
                                  validator: (value) {
                                    value = value.trim();
                                    if (value.isEmpty ||
                                        !RegExp(r"^\+(?:[0-9] ?){6,14}[0-9]$")
                                            .hasMatch(value))
                                      return "you must enter valid phone number note:put your country code like +963 then your number";
                                  },
                                ),
                          SwitchListTile(
                              title: Text("accept our term"),
                              value: accept_term,
                              onChanged: (value) {
                                setState(() {
                                  accept_term = value;
                                });
                              }),
                          model.isloading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  // color: Colors.lightBlue.shade300,
                                  onPressed: () {
                                    if (key.currentState.validate() &&
                                        accept_term) {
                                      key.currentState.save();
                                      if (state ==
                                          switch_between_login_and_signup
                                              .Signin) {
                                        if (_email == null) print("fuck");

                                        model
                                            .signin_sigup(
                                                email: _email.text,
                                                password: password.text,
                                                type: state)
                                            .then((value) {
                                          if (value["error"]) {
                                            Navigator.pushReplacementNamed(
                                                context, "homepage");
                                          }
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Center(
                                                    child:
                                                        Text(value["message"]),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          "ok",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ))
                                                  ],
                                                );
                                              });
                                        });
                                      } else {
                                        model
                                            .signin_sigup(
                                                email: _email.text,
                                                password: password.text,
                                                type: state,
                                                first_name: first_name.text,
                                                date_of_birth:
                                                    date_of_birth.text,
                                                last_name: last_name.text,
                                                phone_number: phone_number.text)
                                            .then((value) {
                                          if (value["error"]) {
                                            Navigator.pushReplacementNamed(
                                                context, "homepage");
                                          }
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Center(
                                                    child:
                                                        Text(value["message"]),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          "ok",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ))
                                                  ],
                                                );
                                              });
                                        });
                                      }
                                    }
                                  },
                                  child: Text(state ==
                                          switch_between_login_and_signup.Signin
                                      ? "sign in"
                                      : "sign up")),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if (state ==
                                      switch_between_login_and_signup.Signin) {
                                    state =
                                        switch_between_login_and_signup.Signup;
                                  } else {
                                    state =
                                        switch_between_login_and_signup.Signin;
                                  }
                                });
                              },
                              child: Text(
                                state == switch_between_login_and_signup.Signin
                                    ? "switch to sign up"
                                    : "switch to sign in",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      )))))),
        );
      },
    );
  }
}
