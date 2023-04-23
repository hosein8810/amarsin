import 'package:flutter/material.dart';

class m2 extends StatefulWidget {
  const m2({super.key});

  @override
  State<m2> createState() => _m2State();
}

class _m2State extends State<m2> {


  @override
  Widget build(BuildContext context) {
    bool specialPart = false;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StatefulBuilder(
      builder: (stfContext,stfSetState) {
        return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              content: SizedBox(
                                width: width * 0.8,
                                height: height * 0.8,
                                child: Container(
                                  child: ListView(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text('نام'),
                                            SizedBox(
                                              width: width * 0.3,
                                              height: 10,
                                              // child: Expanded(
                                              child: Material(
                                                  color: Color.fromARGB(
                                                      255, 231, 231, 231),
                                                  child: TextField()),
                                              //   ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text('آیکون'),
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Icon(Icons.cloud_upload_outlined),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Text('برند ها')],
                                    ),
                                    Container(
                                      color: Color.fromARGB(255, 231, 231, 231),
                                      child: SizedBox(
                                        width: 50,
                                        height: height * 0.5 - 20,
                                        child: Container(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemBuilder: ((context, index) =>
                                                Text('data')),
                                            itemCount: 100,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Text('بخش ویژه:')],
                                    ),
                                    ElevatedButton(
                                      child: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.red,
                                      ),
                                      onPressed: (() {
                                    setState(() {
                                      specialPart = !specialPart;
                                    });
                                      }),
                                    ),
                                    Visibility(
                                      child: Container(
                                      color: Color.fromARGB(255, 231, 231, 231),
                                      child: SizedBox(
                                        width: 50,
                                        height: height * 0.5 - 20,
                                        child: Container(
                                          // child: ListView.builder(
                                          //   shrinkWrap: true,
                                          //   physics: ScrollPhysics(),
                                          //   itemBuilder: ((context, index) =>
                                          //       Text('data')),
                                          //   itemCount: 100,
                                          // ),
                                        ),
                                      ),
                                    ),
                                    visible: specialPart,)
                                  ]),
                                ),
                              ),
                            ),
                          );
      }
    );
  }
}
