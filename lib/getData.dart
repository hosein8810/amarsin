import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/DataModle.dart';
import 'package:untitled2/LoginDataModle.dart';

void getData(String userName, BuildContext context,DataModel dataModel,) async {

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = '${dataModel.Url}UserApi/login?_userName=${userName}&_pass=123&player_id=0&_customerTyp=9';
    http.Response response = await http.get(Uri.parse(url));
    var dataResponse = json.decode(utf8.decode(response.bodyBytes));
    var meta = (dataResponse as Map)["Meta"];
    var data = (dataResponse as Map)["Data"]["result"];
    var loginDataModel = LoginDataModel(meta['errorCode'], meta['message'], data['Perms'].split(','));
    if(meta['errorCode']==-1)
    prefs.setBool("isLoggedIn", false);
  }catch (e) {
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