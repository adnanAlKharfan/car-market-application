import 'package:flutter/material.dart';
import 'package:interview_app/pages/add.dart';
import '../models/connected_scope_model.dart';
import 'package:scoped_model/scoped_model.dart';

class edit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _edit();
  }
}

class _edit extends State<edit> {
  @override
  void initState() {
    ScopedModelDescendant<Auth_model>(
        builder: (BuildContext context, Widget child, Auth_model model) {
      model.index = -1;
      model.getalls();
    });
    // TODO: implement initState
    super.initState();
  }

  Widget retrive(Auth_model model) {
    Widget child = Center(child: Text("no item yet"));
    if (model.products.length > 0 && !model.isloading) {
      child = ListView.builder(
          itemCount: model.products.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(model.products[index].name),
                onDismissed: (direction) {
                  try {
                    model.index = index;
                    model.delete();
                  } catch (e) {
                    print(e);
                  }
                },
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  child: Container(
                      padding: EdgeInsets.only(right: 100.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Remove",
                            textAlign: TextAlign
                                .center /*TextAlign.values(TextAlign.center,TextAlign.end)*/,
                            style:
                                TextStyle(fontSize: 26.0, color: Colors.white),
                          ))),
                ),
                child: Column(children: [
                  ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            model.products[index].updatedImage != null
                                ? FileImage(model.products[index].updatedImage)
                                : NetworkImage(model.products[index].image)),
                    title: Text(model.products[index].name),
                    subtitle:
                        Text("\$" + model.products[index].price.toString()),
                    trailing: IconButton(
                        onPressed: () {
                          //  model.select(index);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            model.index = index;
                            return add(
                              ind: model.index,
                            );
                          }));
                        },
                        icon: Icon(Icons.edit)),
                  ),
                  Divider(),
                ]));
          });
    } else if (model.isloading) {
      child = Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
        child: child,
        onRefresh: () async {
          return model.getalls();
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<Auth_model>(
        builder: (BuildContext context, Widget child, Auth_model model) {
      return retrive(model);
    });
  }
}
