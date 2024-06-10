import 'package:flutter/material.dart';
import 'package:interview_app/pages/details.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/connected_scope_model.dart';
import '../classes/cars.dart';
import '../models/connected_scope_model.dart';

class homepage extends StatefulWidget {
  final Function logout;
  final Auth_model model;
  homepage(this.logout, this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _homepage();
  }
}

class _homepage extends State<homepage> {
  @override
  void initState() {
    // TODO: implement initState
    widget.model.getall();
    super.initState();
  }

  Widget retriver() {
    Widget childs = Center(
      child: Text("no data found"),
    );

    List<cars> product = widget.model.product_list;
    if (product.length > 0 && !widget.model.isloading) {
      childs = ListView.builder(
        itemCount: product.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                widget.model.index = index;
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return details();
                })).then((_) {
                  widget.model.index = -1;
                });
              },
              child: Hero(
                  tag: product[index].id,
                  child: Card(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            image: product[index].updatedImage != null
                                ? FileImage(product[index].updatedImage)
                                : NetworkImage(product[index].image),
                            placeholder: AssetImage("image.jpg"),
                            height: MediaQuery.of(context).size.height / 5,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  product[index].name,
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .aspectRatio *
                                          60,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'osbold'),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Text(
                                      "\$" + product[index].price.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .aspectRatio *
                                              60),
                                    ))
                              ]),
                        ),
                      ],
                    ),
                  ))));
        },
      );
    } else if (widget.model.isloading) {
      childs = Center(
          child: CircularProgressIndicator(
        strokeWidth: 10.0,
      ));
    }
    return RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: childs,
        onRefresh: () async {
          return FutureBuilder(future: widget.model.getall());
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<Auth_model>(
        builder: (BuildContext context, Widget child, Auth_model model) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
              ),
              widget.model.allowediting == false
                  ? Center()
                  : ListTile(
                      title: Text("products edit"),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'edit');
                      },
                    ),
              ListTile(
                  title: Text("contact us"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'contact');
                  }),
              ListTile(
                title: Text("Log out"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () => widget.logout(),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Align(
              alignment:
                  Alignment.lerp(Alignment.center, Alignment.centerLeft, 0.2),
              child: Text("our cars")),
        ),
        body: retriver(),
      );
    });
  }
}
