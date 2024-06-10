import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:interview_app/classes/state.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../classes/sign_in.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

import '../classes/cars.dart';

class Auth_model extends Model {
  bool isloading = false;
  bool allowediting = false;
  int index = -1;
  List<cars> products = [];
  user admin;
  PublishSubject<bool> login = PublishSubject();
  Future<Map> signin_sigup(
      {String email,
      String password,
      switch_between_login_and_signup type,
      String first_name,
      String last_name,
      String phone_number,
      String date_of_birth}) async {
    isloading = true;
    notifyListeners();
    await WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    http.Response res;
    if (type == switch_between_login_and_signup.Signin) {
      res = await http.post(
          Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBJ81r8Erpsg9lkkrJJYnpSbixY69ulgFc'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
    } else {
      res = await http.post(
          Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBJ81r8Erpsg9lkkrJJYnpSbixY69ulgFc'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
    }

    Map resbody = json.decode(res.body);
    String message = "no connection";
    bool haserror = true;

    if (resbody.containsKey("idToken")) {
      haserror = false;
      message = "welcome";
      admin =
          user(email: email, id: resbody["localId"], token: resbody["idToken"]);
      if (email == "test@test.com" || email == "bestadnan8@gmail.com") {
        allowediting = true;
      }

      login.add(true);
    } else if (resbody["error"]["message"] == "EMAIL_NOT_FOUND") {
      message = "there is no email like that";
      login.add(false);
    } else if (resbody["error"]["message"] == "INVALID_PASSWORD") {
      message = "check your password";
      login.add(false);
    } else if (resbody["error"]["message"] == "USER_DISABLED") {
      message = "user disabled";
      login.add(false);
    } else if (resbody["error"]["message"] == "EMAIL_EXISTS") {
      message = "you already signed up using this email";
      login.add(false);
    } else if (resbody["error"]["message"] == "OPERATION_NOT_ALLOWED") {
      message = "you're not allowed no more";
      login.add(false);
    } else if (resbody["error"]["message"] == "TOO_MANY_ATTEMPTS_TRY_LATER") {
      message = "please try later";
      login.add(false);
    }

    isloading = false;
    notifyListeners();
    return {"error": !haserror, "message": message};
  }

  void logout() async {
    login.add(false);
    admin = null;
    allowediting = false;
  }

  /*void sendfile(File image, String name) async {
    String filename = image.path.split('/').last;

    filename = name + "." + filename.split('.').last;
    FormData formData = new FormData.fromMap({
      "submit": "wendux",
      "file": new MultipartFile.fromString(image.path, filename: filename)
    });
    print("hi");
    print(formData.fields.first);
    final response = await Dio()
        .post("http://192.168.1.107/flutter_file.php", data: formData);
    print(response);
    await http.post("http://192.168.1.107/flutter_file.php", body: {
      "upload": "add",
      "name": filename,
      "image": base64Encode(image.readAsBytesSync())
    });
  }*/

  Future<bool> add(
      {String image,
      String name,
      double price,
      String description,
      String phone}) async {
    isloading = true;
    notifyListeners();
    http.Response res = await http.post(
        Uri.parse(
            "https://adnan-first.firebaseio.com/product.json?auth=${admin.token}"),
        body: jsonEncode({
          "name": name,
          "price": price,
          "description": description,
          "phone": phone,
          "image": ""
        }));

    if (res.statusCode < 400) {
      Map o = jsonDecode(res.body);

      await putthelink(o["name"], name, price, description, phone, image);
      isloading = false;
      notifyListeners();
      return true;
    }
    isloading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateproduct(
      {File imagef,
      String name,
      double price,
      String description,
      String phone,
      String image}) async {
    isloading = true;
    notifyListeners();
    print("hi");
    if (imagef != null) {
      products[index].updatedImage = imagef;
      await FirebaseStorage.instance.ref().child(products[index].id).delete();
      await FirebaseStorage.instance
          .ref()
          .child(products[index].id)
          .putFile(File(imagef.path));
      image = await FirebaseStorage.instance
          .ref()
          .child(products[index].id)
          .getDownloadURL();
    }
    http.Response res = await http.put(
        Uri.parse(
            "https://adnan-first.firebaseio.com/product/${products[index].id}.json?auth=${admin.token}"),
        body: jsonEncode({
          "name": name,
          "price": price,
          "description": description,
          "phone": phone,
          "image": image
        }));
    products[index] = cars(
        updatedImage: products[index].updatedImage == null
            ? null
            : products[index].updatedImage,
        id: products[index].id,
        name: name,
        phone: phone,
        description: description,
        image: products[index].image,
        price: price);
    print(res.statusCode);

    isloading = false;
    notifyListeners();
    return true;
  }

  List<cars> get product_list {
    return List.from(products);
  }

  Future<Null> putthelink(String id, String name, double price,
      String description, String phone, String image) async {
    isloading = true;
    notifyListeners();
    String u = id;
    if (image != null) {
      await FirebaseStorage.instance.ref().child(id).putFile(File(image));
      image = await FirebaseStorage.instance.ref().child(id).getDownloadURL();
    }
    await http.put(
        Uri.parse(
            "https://adnan-first.firebaseio.com/product/${u}.json?auth=${admin.token}"),
        body: jsonEncode({
          "name": name,
          "price": price,
          "description": description,
          "phone": phone,
          "image": image
        }));
    isloading = false;
    notifyListeners();
  }

  Future<void> getall() async {
    isloading = true;
    notifyListeners();
    // print("hi1");
    //bool alluser = false;
    //if (admin.email == "test@test.com") {
    // alluser = true;
    //}

    // isloading = true;
    // notifyListeners();
    Map<String, dynamic> pp;

    await http
        .get(Uri.parse(
            "https://adnan-first.firebaseio.com/product.json?auth=${admin.token}"))
        .then((http.Response res) {
      pp = json.decode(res.body);
      if (pp != null) {
        pp.forEach((String id, dynamic k) {
          print(k);
          if (products.length == 0) {
            products.add(cars(
                id: id,
                name: k["name"],
                description: k["description"],
                price:double.parse(k["price"].toString()),
                image: k["image"],
                phone: k["phone"]));
          } else {
            bool add_this = true;
            for (int j = 0; j < products.length; j++) {
              if (id == products[j].id) {
                add_this = false;
              }
            }
            if (add_this) {
              print(k["image"]);
              products.add(cars(
                  id: id,
                  name: k["name"],
                  description: k["description"],
                  price: double.parse(k["price"].toString()),
                  image: k["image"],
                  phone: k["phone"]));
            }
          }
        });
      }
      print("hi2");
      isloading = false;
      notifyListeners();
    });
    print("hi2");
    isloading = false;
    notifyListeners();
  }

  Future getalls() async {
    isloading = true;
    notifyListeners();
    print("hi1");
    //bool alluser = false;
    //if (admin.email == "test@test.com") {
    // alluser = true;
    //}
    List<cars> temp = [];
    // isloading = true;
    // notifyListeners();
    Map<String, dynamic> pp;

    await http
        .get(Uri.parse(
            "https://adnan-first.firebaseio.com/product.json?auth=${admin.token}"))
        .then((http.Response res) {
      pp = json.decode(res.body);
      if (pp != null) {
        pp.forEach((String id, dynamic k) {
          if (products.length == 0) {
            products.add(cars(
                id: id,
                name: k["name"],
                description: k["description"],
                price: double.parse(k["price"].toString()),
                image: k["image"],
                phone: k["phone"]));
          } else {
            bool add_this = true;
            for (int j = 0; j < products.length; j++) {
              if (id == products[j].id) {
                add_this = false;
              }
            }
            if (add_this) {
              print(k["image"]);
              products.add(cars(
                  id: id,
                  name: k["name"],
                  description: k["description"],
                  price: double.parse(k["price"].toString()),
                  image: k["image"],
                  phone: k["phone"]));
            }
          }
        });
      }
      print("hi2");
      isloading = false;
      notifyListeners();
    });
    print("hi2");
    isloading = false;
    notifyListeners();
  }

  void delete() async {
    isloading = true;
    notifyListeners();
    String id = products[index].id;
    String image = products[index].image;
    products.removeAt(index);

    await FirebaseStorage.instance.ref().child(id).delete();
    await http.delete(Uri.parse(
        "https://adnan-first.firebaseio.com/product/${id}.json?auth=${admin.token}"));

    // index = -1;

    isloading = false;
    notifyListeners();
  }
}
