import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import '../models/connected_scope_model.dart';
import '../classes/cars.dart';
import 'package:firebase_storage/firebase_storage.dart';

class add extends StatefulWidget {
  final ind;
  add({this.ind});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add();
  }
}

class _add extends State<add> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  ImagePicker pick = ImagePicker();
  var data;
  File imagefile;
  Widget showforimage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.all(10.0),
              height: 150.0,
              child: Column(
                children: [
                  OutlinedButton(
                    child: Text("take an image"),
                    onPressed: () async {
                      ImagePicker()
                          .getImage(source: ImageSource.camera, maxWidth: 400.0)
                          .then((value) {
                        setState(() {
                          imagefile = File(value.path);
                        });

                        Navigator.pop(context);
                      });
                    },
                  ),
                  OutlinedButton(
                    child: Text("pick an image"),
                    onPressed: () async {
                      data = ImagePicker()
                          .getImage(
                              source: ImageSource.gallery, maxWidth: 400.0)
                          .then((value) {
                        setState(() {
                          imagefile = File(value.path);

                          // model.sendfile(imagefile);
                        });
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
              ));
        });
  }

  final _titlecontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();
  final _pricecontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  String first_input = "ok";
  String descreption = "";
  double price = 0.0;
  String phone;

  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.of(context).size.width;
    double devicetarget = devicewidth > 550.0 ? 500.0 : devicewidth * 0.95;
    double paddintarget = devicewidth - devicetarget;
    // TODO: implement build
    return ScopedModelDescendant<Auth_model>(builder: (context, child, model) {
      if (widget.ind != null) {
        final prol = model.product_list;
        cars prod = prol[model.index];
        Image o = prol[model.index].updatedImage == null
            ? Image.network(prod.image)
            : Image.file(prod.updatedImage);
        if (_titlecontroller.text == "" &&
            _descriptioncontroller.text == "" &&
            _pricecontroller.text == "" &&
            _phonecontroller.text == "") {
          _titlecontroller.text = prod.name;
          _descriptioncontroller.text = prod.description;
          _pricecontroller.text = prod.price.toString();
          _phonecontroller.text = prod.phone;
        }
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text(prod.name)),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Form(
                    key: key,
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: paddintarget / 2),
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'car title'),
                          controller: _titlecontroller,
                          validator: (value) {
                            if (value.isEmpty ||
                                !RegExp(r'[a-zA-Z]').hasMatch(value)) {
                              return "title is required";
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(labelText: 'your phone'),
                          controller: _phonecontroller,
                          validator: (value) {
                            value = value.trim();
                            if (value.isEmpty ||
                                !RegExp(r"^\+(?:[0-9] ?){6,14}[0-9]$")
                                    .hasMatch(value))
                              return "you must enter valid phone number note:put your country code like +963 then your number";
                          },
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: "car description",
                                border: InputBorder.none),
                            controller: _descriptioncontroller,
                            maxLines: 10,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "enter vaild price";
                              }
                            }),
                        TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration:
                              InputDecoration(labelText: "product price"),
                          controller: _pricecontroller,
                          validator: (value) {
                            value = value.trim();
                            if (value.isEmpty) {
                              return "enter vaild price";
                            }
                          },
                        ),
                        OutlinedButton(
                            // borderSide:
                            //     BorderSide(color: Colors.orange, width: 3.0),
                            // color: Colors.orange,
                            onPressed: () {
                              showforimage(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "pick a pic",
                                  style: TextStyle(color: Colors.orange),
                                )
                              ],
                            )),
                        imagefile == null
                            ? o
                            : Image.file(
                                imagefile,
                              ),
                        SizedBox(
                          height: 10.0,
                        ),
                        model.isloading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                // color: Theme.of(context).accentColor,
                                onPressed: () {
                                  if (!key.currentState.validate()) {
                                    return null;
                                  }
                                  key.currentState.save();

                                  if (imagefile != null) {
                                    model
                                        .updateproduct(
                                            imagef: imagefile,
                                            name: _titlecontroller.text.trim(),
                                            description:
                                                _descriptioncontroller.text,
                                            price: double.parse(
                                                _pricecontroller.text.trim()),
                                            phone: _phonecontroller.text.trim())
                                        .then((value) {
                                      if (value) Navigator.pop(context);
                                    });
                                  } else {
                                    model
                                        .updateproduct(
                                            image: prod.image,
                                            name: _titlecontroller.text.trim(),
                                            description:
                                                _descriptioncontroller.text,
                                            price: double.parse(
                                                _pricecontroller.text.trim()),
                                            phone: _phonecontroller.text.trim())
                                        .then((value) {
                                      if (value) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                },
                                child: Center(child: Text("save")),
                              )
                      ],
                    ),
                  ),
                )));
      } else {
        return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                margin: EdgeInsets.all(10.0),
                child: Form(
                    key: key,
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: paddintarget / 2),
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'car title'),
                          controller: _titlecontroller,
                          validator: (value) {
                            if (value.isEmpty ||
                                !RegExp(r'[a-zA-Z]').hasMatch(value)) {
                              return "title is required";
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(labelText: 'your phone'),
                          controller: _phonecontroller,
                          validator: (value) {
                            value = value.trim();
                            if (value.isEmpty ||
                                !RegExp(r"^\+(?:[0-9] ?){6,14}[0-9]$")
                                    .hasMatch(value))
                              return "you must enter valid phone number note:put your country code like +963 then your number";
                          },
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: "car description",
                                border: InputBorder.none),
                            controller: _descriptioncontroller,
                            maxLines: 10,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "enter vaild price";
                              }
                            }),
                        TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration:
                              InputDecoration(labelText: "product price"),
                          controller: _pricecontroller,
                          validator: (value) {
                            value = value.trim();
                            if (value.isEmpty) {
                              return "enter vaild price";
                            }
                          },
                        ),
                        OutlinedButton(
                            // borderSide:
                            //     BorderSide(color: Colors.orange, width: 3.0),
                            // color: Colors.orange,
                            onPressed: () {
                              showforimage(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "pick a pic",
                                  style: TextStyle(color: Colors.orange),
                                )
                              ],
                            )),
                        imagefile == null
                            ? Center(
                                child: Text(
                                  "please insert a pic",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : Image.file(
                                imagefile,
                              ),
                        model.isloading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if (key.currentState.validate() &&
                                      imagefile != null) {
                                    _pricecontroller.text
                                        .trim()
                                        .replaceAll(",", ".");
                                    model
                                        .add(
                                            image: imagefile.path,
                                            name: _titlecontroller.text.trim(),
                                            description:
                                                _descriptioncontroller.text,
                                            price: double.parse(
                                                _pricecontroller.text.trim()),
                                            phone: _phonecontroller.text.trim())
                                        .then((value) {
                                      if (value) {
                                        Navigator.pushReplacementNamed(
                                            context, 'homepage');
                                      }
                                    });
                                  }
                                },
                                child: Text("save"),
                              )
                      ],
                    ))));
      }
    });
  }
}
