import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/connected_scope_model.dart';

class contact_us extends StatelessWidget {
  final Function logout;
  contact_us(this.logout);
  @override
  Widget build(BuildContext context) {
    double device_height = MediaQuery.of(context).size.height;
    double target_height = device_height > 550 ? 500 : device_height * 0.95;
    double target_padding = device_height - target_height;
    // TODO: implement build
    return ScopedModelDescendant<Auth_model>(
        builder: (BuildContext context, Widget child, Auth_model model) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
              ),
              ListTile(
                  title: Text("homepage"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'homepage');
                  }),
              model.allowediting == false
                  ? Center()
                  : ListTile(
                      title: Text("products"),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'edit');
                      }),
              ListTile(
                title: Text("Log out"),
                trailing: Icon(Icons.exit_to_app),
                onTap: logout,
              )
            ],
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 150.0,
                backgroundImage: AssetImage("adnan.png"),
              ),
              TextButton(
                  onPressed: () async {
                    String mail = "sms:+963994357358";
                    if (await canLaunch(mail)) {
                      launch(mail);
                    } else {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("something wrong went on"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("ok"))
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("+963994357358")),
              TextButton(
                  onPressed: () async {
                    String mail = "mailto:bestadnan8@gmail.com";
                    if (await canLaunch(mail)) {
                      launch(mail);
                    } else {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("something wrong went on"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("ok"))
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("bestadnan8@gmail.com"))
            ],
          ),
        )),
      );
    });
  }
}
