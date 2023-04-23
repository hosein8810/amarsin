import 'dart:io';

import 'package:flutter/material.dart';
import 'package:amarsin/DataModle.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amarsin/Home.dart';
import 'package:amarsin/LoginDataModle.dart';

class Login extends StatefulWidget {
  final DataModel dataModel;
  Login({Key? key, required this.dataModel}) : super(key: key);

  @override
  State<Login> createState() => _loginState(dataModel: dataModel);
}

class _loginState extends State<Login> {
  final DataModel dataModel;
  _loginState({required this.dataModel});
  bool lodeing = false;
  var userName = TextEditingController();
  var pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: ListView(
              children: [
                SizedBox(
                  height: 60,
                ),
                SizedBox(
                  height: 100,
                  child: Image.network(
                      'assets/assets/assets/drawable-hdpi/logo.png'),
                ),
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    width: MediaQuery.of(context).size.width - 50,
                    height: 280,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 10.0, top: 5.0, left: 10.0, bottom: 0.0),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'خوش آمدید',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.settings)),
                            ],
                          ),
                          //SizedBox(height: 10,),
                          Row(
                            children: [
                              Text('وارد حساب کار بری خود شوید'),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 45,
                            child: Material(
                              elevation: 0,
                              borderRadius: BorderRadius.circular(40),
                              child: TextField(
                                //obscureText: true,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    //counterText: "کد فعال ساز",
                                    hintText: "نام کاربری",
                                    icon: Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child:
                                          Icon(Icons.account_circle_outlined),
                                    )),
                                controller: userName,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 45,
                            child: Material(
                              elevation: 0,
                              borderRadius: BorderRadius.circular(40),
                              child: TextField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    //counterText: "کد فعال ساز",
                                    hintText: "رمز عبور",
                                    icon: Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(Icons.lock),
                                    )),
                                controller: pass,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 43,
                            width: 110,
                            child: Material(
                              elevation: 0,
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.blueAccent,
                              child: InkWell(
                                  onTap: () {
                                    getData(userName.text, pass.text, context);
                                  },
                                  child: SizedBox(
                                    height: 70,
                                    child: Center(
                                      child: lodeing
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : const Text(
                                              'ورود',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
        theme: ThemeData(fontFamily: 'sans_bold'),
      ),
    );
  }

  void getData(
    String userName,
    String pass,
    BuildContext context,
  ) async {
    try {
      setState(() {
        lodeing = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userName', userName);
      prefs.setString('pass', pass);
      var url =
          '${dataModel.url}UserApi/login?_userName=${userName}&_pass=${pass}&player_id=0&_customerTyp=9';
      http.Response response = await http.get(Uri.parse(url));
      var dataResponse = json.decode(utf8.decode(response.bodyBytes));
      var meta = (dataResponse as Map)["Meta"];
      var data = (dataResponse as Map)["Data"]["result"];
      if (meta['errorCode'] == -1) {
        var loginDataModel = LoginDataModel(meta['errorCode'], meta['message'],
            data['userId'], data['Perms'].split(','));
        if (loginDataModel.errorCode == -1) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainPage(
                        dataModel: dataModel,
                      )));
          prefs.setInt('userId', loginDataModel.userId);
          prefs.setBool("isLoggedIn", false);
          prefs.setInt('userId', loginDataModel.userId);
          setState(() {
            lodeing = false;
          });
        } else {
          _showToast(context, meta['message']);
          setState(() {
            lodeing = false;
          });
        }
      } else {
        setState(() {
          lodeing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              meta['message'],
              style: TextStyle(fontFamily: 'sans_bold'),
            ),

            //action: ,SnackBarAction(, onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
        _showToast(context, 'message');
      }
      setState(() {
        lodeing = false;
      });
    } on SocketException catch (e) {
      setState(() {
        lodeing = false;
        _showToast(context, 'خطا در ارتباط');
      });
      //var r = e['message'];
      _showToast(context, 'خطا در ارتباط');
    }

    //var dataResponse = json.decode(utf8.decode(response.bodyBytes));
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: 'sans_bold'),
        ),

        //action: ,SnackBarAction(, onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
