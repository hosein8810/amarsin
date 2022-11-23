import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/Home.dart';
import 'package:untitled2/Login.dart';

import 'DataModle.dart';

Future InitialSettings_dialog(DataModel dataModel, SharedPreferences prefs,BuildContext context) => showDialog(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Center(child: Text('تنظیمات اولیه')),
        content: SizedBox(
          height: 200,
          width: 50,
          child: Expanded(
            child: ListView(
              children: [
                SizedBox(
                    height: 100,
                    width: 100,
                    child:
                    Expanded(child: Image.network(dataModel.LogoUrl))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('عنوان'),
                    Text(dataModel.AppTitle),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('صاحب امتیاز'),
                    Text(dataModel.OwnerName),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('تاریخ ثبت'),
                    Text(dataModel.RegDate),
                  ],
                )
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                //pushReplacement
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login(
                          dataModel: dataModel,
                        )));
              },
              child: Text(
                'تایید',
                style: TextStyle(color: Colors.green),
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
    ));