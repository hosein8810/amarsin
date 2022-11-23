
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/DataModle.dart';
import 'package:untitled2/Home.dart';
import 'package:untitled2/LoginDataModle.dart';
import 'package:untitled2/config.dart';

late LoginDataModel loginDataModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool('isLoggedIn') ?? false;
  int mobileAppUrlId = prefs.getInt('MobileAppUrlId') ?? 0;
  String appTitle = prefs.getString('AppTitle') ?? '';
  String url = prefs.getString('Url') ?? '';
  int systemId = prefs.getInt('systemId') ?? 0;
  // String userName = prefs.getString('userName') ?? '';
  var dataModel =
      DataModel(0, '', mobileAppUrlId, appTitle, '', '', url, '', systemId);

  runApp((status == true
      ? const Config()
      : MainPage(
          dataModel: dataModel,
        )));
}
