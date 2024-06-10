import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../classes/cars.dart';
import '../models/connected_scope_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class details extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _details();
  }
}

class _details extends State<details> with TickerProviderStateMixin {
  AnimationController _controller;
  bool o = true;
  bool off = false;
  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    super.initState();
  }

  Widget changebutton() {
    if (_controller.isDismissed && o) {
      return Icon(Icons.add);
    } else {
      if (off) {
        o = o;
      } else {
        o = !o;
      }
      if (o) {
        return Icon(Icons.add);
      } else
        return Icon(Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<Auth_model>(
      builder: (BuildContext context, Widget child, Auth_model model) {
        final List<cars> prod = model.product_list;
        final cars k = prod[model.index];
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: CustomScrollView(slivers: [
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(k.name),
                background: Hero(
                  tag: k.id,
                  child: FadeInImage(
                      image: k.updatedImage != null
                          ? FileImage(k.updatedImage)
                          : NetworkImage(k.image),
                      placeholder: AssetImage("photo.jpg"),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Text(
                "\$" + k.price.toString(),
                textScaleFactor: 3.0,
                overflow: TextOverflow.visible,
                strutStyle: StrutStyle(
                  fontWeight: FontWeight.w100,
                ),
              ),
              Padding(padding: EdgeInsets.all(10), child: Text(k.description))
            ])),
          ]),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                  scale: CurvedAnimation(
                      parent: _controller,
                      curve: Interval(0.0, 1.0, curve: Curves.easeIn)),
                  child: Container(
                    height: 70.0,
                    width: 40.0,
                    child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        heroTag: "contact",
                        child: Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        mini: true,
                        onPressed: () async {
                          final url = "sms:${k.phone}";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Text("you don't have connection"),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('ok'))
                                      ],
                                    ),
                                  );
                                });
                          }
                        }),
                  )),
              Container(
                  height: 70.0,
                  width: 56.0,
                  child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          if (_controller.isDismissed) {
                            setState(() {
                              off = false;
                              _controller.forward();
                            });
                          } else {
                            setState(() {
                              off = false;
                              _controller.reverse();
                            });
                          }
                        });
                      },
                      heroTag: "expand",
                      child: AnimatedBuilder(
                          animation: _controller,
                          child: changebutton(),
                          builder: (BuildContext context, Widget child) {
                            return Transform(
                              origin: Offset(12.5, 12.0),
                              transform: Matrix4.rotationZ(
                                  (_controller.value * math.pi)),
                              child: child,
                            );
                          })))
            ],
          ),
        );
      },
    );
  }
}
