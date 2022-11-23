
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/DataModle.dart';
import 'package:untitled2/scan.dart';

import 'config.dart';


class drawer extends StatelessWidget {
  final DataModel dataModel;
  drawer({Key? key,required this.dataModel}) : super(key: key);
  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [H(context,), M(context)],
      ),
    ),
  );

  Widget H(BuildContext context) => Container(
    color: Colors.blue,
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    child: const SizedBox(
      height: 160,
    ),
  );

  Widget M(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    child: Wrap(
      runSpacing: 0,
      children: [
        Center(child: Text(dataModel.AppTitle)),
        dl(
          'پروفایل',
          Icon(
            Icons.account_circle_outlined,
            color: Colors.blue[200],
          ),
          context,
          MaterialPageRoute(builder: (context) => const Scan()),
        ),
        dl(
          'تغییر سیستم',
          const Icon(
            Icons.settings,
            color: Colors.blueAccent,
          ),
          context,
          MaterialPageRoute(builder: (context) => const Config()),
        ),
        ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.blueAccent,
            ),
            title: Text('خروج'),
            onTap: () async {
              Navigator.pop(context);
              Exit_dialog(context);
            }),
      ],
    ),
  );
  Future Exit_dialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Center(child: Text('خروج')),
          content: Text('ایا مایل به خروج هستید!؟'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      WidgetsFlutterBinding.ensureInitialized();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isLoggedIn', true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Config();
                        }),
                      );
                    },
                    child: Text(
                      'خروج از حساب کاربری',
                      style: TextStyle(color: Colors.blueAccent),
                    )),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          exit(0);
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
              ],
            ),
          ],
        ),
      ));
}

ListTile dl(
    String name,
    Widget icon,
    BuildContext context,
    MaterialPageRoute jjj,
    ) {
  return ListTile(
      leading: icon,
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, jjj
          // MaterialPageRoute(builder: (context) => const MyApp()),
        );
      });
}