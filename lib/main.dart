import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amarsin/DataModle.dart';
import 'package:amarsin/Home.dart';
import 'package:amarsin/LoginDataModle.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:amarsin/initial%20Settings.dart';

late LoginDataModel loginDataModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool('isLoggedIn') ?? true;
  //int mobileAppUrlId = prefs.getInt('MobileAppUrlId') ?? 0;
  String appTitle = prefs.getString('AppTitle') ?? '';
  String url = prefs.getString('Url') ?? '';
  int systemId = prefs.getInt('systemId') ?? 0;
  // String userName = prefs.getString('userName') ?? '';
  var dataModel = DataModel(0, appTitle, '', '', url, '', systemId);

  runApp((status
      ? const Config()
      : MainPage(
          dataModel: dataModel,
        )));
}

class Config extends StatelessWidget {
  const Config({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: config(),
        theme: ThemeData(fontFamily: 'sans_bold'),
      ),
    );
  }
}

class config extends StatefulWidget {
  const config({Key? key}) : super(key: key);

  @override
  State<config> createState() => _configState();
}

class _configState extends State<config> {
  var loginCode = TextEditingController();
  var editServer = TextEditingController();
  bool loding = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: 60,
            ),
            SizedBox(
              height: 100,
              child:
                  Image.network('assets/assets/assets/drawable-hdpi/logo.png'),
            ),
            const SizedBox(
              height: 60,
            ),
            Center(
              child: Container(
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width - 50,
                height: 230,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10.0, top: 5.0, left: 10.0, bottom: 0.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'خوش آمدید',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: () {
                                EditServer_dialog();
                              },
                              icon: Icon(Icons.settings)),
                        ],
                      ),
                      //SizedBox(height: 10,),
                      Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text('لطفا برای دسترسی بیشتر ..'),
                        ],
                      ),
                      Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'کد فعال سازی نرم افزار را وارد نمایید.',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 45,
                        child: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.circular(40),
                          child: TextField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                //counterText: "کد فعال ساز",
                                hintText: "کد فعال ساز",
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.lock),
                                )),
                            controller: loginCode,
                          ),
                        ),
                      ),
                      const SizedBox(
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
                              getData(loginCode.text, context);
                            },
                            child: SizedBox(
                              height: 70,
                              child: Center(
                                child: loding
                                    ? CircularProgressIndicator()
                                    : Text(
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
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  String urll = 'http://amarsin.dotis.ir';
  void getData(String code, BuildContext context) async {
    try {
      setState(() {
        loding = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = '$urll/api/defapi/GetAppsUrl?_code=$code';
      print(url);
      http.Response response = await http.get(Uri.parse(url));
      setState(() async {
        var dataResponse = json.decode(utf8.decode(response.bodyBytes));
        var meta = (dataResponse as Map)["Meta"];
        var data = (dataResponse as Map)["Data"]["result"];
        if (meta['errorCode'] == -1) {
          var dataa = DataModel(
              data['MobileAppUrlId'],
              data['AppTitle'],
              data['OwnerName'],
              data['RegDate'],
              data['Url'],
              data['LogoUrl'],
              data['SystemId']);
          print('object');
          print(dataa);
          print('111111');
          //prefs.setString('errorCode', meta['errorCode']);
          prefs.setInt('errorCode', meta['errorCode']);
          prefs.setInt('MobileAppUrlId', data['MobileAppUrlId']);
          prefs.setString('AppTitle', data['AppTitle']);
          prefs.setString('Url', data['Url']);
          prefs.setInt('systemId', data['SystemId']);
          InitialSettings_dialog(dataa, prefs, context);
          setState(() {
            loding = false;
          });
        } else {
          setState(() {
            loding = false;
          });
          _showToast(context, meta['message']);
        }
      });
    } on SocketException catch (e) {
      //var r = e['message'];
      setState(() {
        loding = false;
      });
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

  Future EditServer_dialog() => showDialog(
      context: context,
      builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Center(child: Text('تغییر سرور')),
              content: SizedBox(
                height: 80,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('آدرس جدید سرور را در فیلد زیر وارد نمایید'),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 45,
                      child: Material(
                        // ignore: sort_child_properties_last
                        child: TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              //counterText: "کد فعال ساز",
                              hintText: "_ _ _ _ _ _",
                              icon: Padding(
                                padding: EdgeInsets.only(right: 10),
                              )),
                          textAlign: TextAlign.center,
                          controller: editServer,
                        ),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          urll = 'http://amarsin.dotis.ir';
                        },
                        child: Text(
                          'بازگردانی',
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              urll = editServer.text;
                            },
                            child: Text(
                              'تایید',
                              style: TextStyle(color: Colors.blue),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'بازگشت',
                              style: TextStyle(color: Colors.red),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ));
}
