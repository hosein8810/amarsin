import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

class routePage extends StatefulWidget {
  const routePage({Key? key}) : super(key: key);

  @override
  State<routePage> createState() => _routePageState();
}

class _routePageState extends State<routePage> {
  Jalali jalali = Jalali.now();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(' برگه مسیر ها'),
        ),
        body: Column(
          children: [
            TextButton(
                child: Text(
                  '${jalali.year}/${jalali.month}/${jalali.day}',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
                onPressed: () {}),
            //SizedBox(height: 8),
            ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                return late(Text('data'), Text((index + 1).toString()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget late(Text text, Text ldng) {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('data'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('data'),
                  Text('data'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('data'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('data'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
