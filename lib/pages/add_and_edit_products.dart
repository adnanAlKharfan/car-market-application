import 'package:flutter/material.dart';
import './add.dart';
import './edit.dart';

class add_and_edit extends StatelessWidget {
  final Function logout;
  add_and_edit(this.logout);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                ListTile(
                    title: Text("contact us"),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'contact');
                    }),
                ListTile(
                  title: Text("Log out"),
                  trailing: Icon(Icons.exit_to_app),
                  onTap: logout,
                )
              ],
            ),
          ),
          appBar: AppBar(
              bottom: TabBar(tabs: [
            Tab(
              text: "create ",
            ),
            Tab(text: "update")
          ])),
          body: TabBarView(children: [add(), edit()]),
        ));
  }
}
