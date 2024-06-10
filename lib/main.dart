import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './pages/sign_in_sign_up_page.dart';
import './models/connected_scope_model.dart';
import './pages/homepage.dart';
import './pages/add_and_edit_products.dart';
import './pages/contact_us.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _myapp();
  }
}

class _myapp extends State<MyApp> {
  Auth_model model = Auth_model();
  bool _login;
  @override
  void initState() {
    if (model.login == null) {
      _login = false;
    } else {
      model.login.listen((value) {
        setState(() {
          if (value == null) {
            _login = false;
          } else {
            _login = value;
          }
        });
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel(
        model: model,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (BuildContext context) {
              return auth_page();
            },
            'homepage': (BuildContext context) {
              return _login ? homepage(model.logout, model) : auth_page();
            },
            'contact': (BuildContext context) {
              return _login ? contact_us(model.logout) : auth_page();
            },
            'edit': (BuildContext context) {
              return _login ? add_and_edit(model.logout) : auth_page();
            }
          },
          onUnknownRoute: (settings) {
            MaterialPageRoute(builder: (context) {
              return _login ? homepage(model.logout, model) : auth_page();
            });
          },
        ));
  }
}
