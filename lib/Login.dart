import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled2/DataModle.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/Home.dart';
import 'package:untitled2/LoginDataModle.dart';



class Login extends StatelessWidget {
  final DataModel dataModel;
   Login({Key? key,required this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userName = TextEditingController();
    var pass = TextEditingController();
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 45,
                ),
                Image.asset('assets\\drawable-hdpi\\Logo.png'),
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
                                  onPressed: () {
                                  },
                                  icon: Icon(Icons.settings)),
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
                            child: Expanded(
                              child: Material(
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //counterText: "کد فعال ساز",
                                      hintText: "نام کاربری",
                                      icon: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Icon(Icons.account_circle_outlined),
                                      )),
                                  controller: userName,
                                ),
                                elevation: 0,
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 45,
                            child: Expanded(
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
                                child: Container(
                                  height: 70,
                                  child: Center(
                                    child: Text(
                                      'برسی کد',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        theme: ThemeData(fontFamily: 'sans_bold'),
      ),
    );
  }

  void getData(String userName, String pass, BuildContext context,) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userName', userName);
      prefs.setString('pass', pass);
      var url = '${dataModel.Url}UserApi/login?_userName=${userName}&_pass=${pass}&player_id=0&_customerTyp=9';
      http.Response response = await http.get(Uri.parse(url));
        var dataResponse = json.decode(utf8.decode(response.bodyBytes));
        var meta = (dataResponse as Map)["Meta"];
        var data = (dataResponse as Map)["Data"]["result"];
      if(meta['errorCode'] == -1){
        var loginDataModel = LoginDataModel(
            meta['errorCode'], meta['message'], data['Perms'].split(','));
        if (loginDataModel.errorCode == -1) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainPage(
                        dataModel: dataModel,
                      )));
          prefs.setBool("isLoggedIn", false);
        } else {
          _showToast(context, meta['message']);
        }
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              meta['message'],
              style: TextStyle(fontFamily: 'sans_bold'),
            ),

            //action: ,SnackBarAction(, onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
      }
    }on SocketException catch (e) {
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