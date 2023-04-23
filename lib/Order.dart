import 'dart:convert';

import 'package:amarsin/DataModle.dart';
import 'package:amarsin/Home.dart';
import 'package:amarsin/streamController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as NumberFormat;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amarsin/OrderMSTmodle.dart';
import 'package:amarsin/add_invoic.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class Order extends StatefulWidget {
  final DataModel dataModel;
  const Order({required this.dataModel});

  @override
  State<Order> createState() => _OrderState(dataModel: dataModel);
}

class _OrderState extends State<Order> {
  List<OrderMSTmodle> orderItem = [];
  Jalali jalali = Jalali.now();
  String selectedDate = Jalali.now().toJalaliDateTime();
  int _selectedIndex = 1;
  int status = 0;
  List<Color> colors = [const Color(0x00000050)];
  final DataModel dataModel;
  _OrderState({required this.dataModel});
  void _onItemsTap(int index) {
    setState(() {
      if (index > 1) {
        status = 403020700 + (index - 1);
      } else if (index == 1) {
        status = 0;
      }
      //40302070status
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat.NumberFormat myformat =
        NumberFormat.NumberFormat.decimalPattern('en_us');
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              bottomNavigationBarItem('پییش نویس', const Icon(Icons.newspaper)),
              bottomNavigationBarItem('پییش فاکتور', const Icon(Icons.newspaper)),
              bottomNavigationBarItem('ثبت', const Icon(Icons.newspaper)),
              bottomNavigationBarItem('توزیع', const Icon(Icons.newspaper)),
              bottomNavigationBarItem('تحویل شده', const Icon(Icons.newspaper)),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemsTap,
            //backgroundColor: Colors.red,
            unselectedItemColor: Colors.grey,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => Add_invoic(stream: streamController.stream,))))
                  .then((value) {
                setState(() {});
              });
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          leading: BackButton(onPressed: (() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(
                          dataModel: dataModel,
                        )));
          })),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.replay))
          ],
          title: const Text(
            'لیست سفارشات',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextButton(
                child: Text(
                  '${jalali.year}/${jalali.month}/${jalali.day}',
                  style: const TextStyle(fontSize: 17, color: Colors.black),
                ),
                onPressed: () async {
                  Jalali? picked = await showPersianDatePicker(
                    context: context,
                    initialDate: Jalali.now(),
                    firstDate: Jalali(1385, 8),
                    lastDate: Jalali.now(),
                  );
                  var label = picked?.toJalaliDateTime();
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      jalali = picked;
                      label = picked.toJalaliDateTime();
                    });
                  }
                }),
            FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: orderItem.length,
                          itemBuilder: (context, index) => Container(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${index + 1} - ${orderItem[index].Code}'),
                                            Text(myformat.format(
                                                orderItem[index].SumTotal)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                            width: width * 89,
                                            child: Text(
                                              orderItem[index].CustName,
                                              maxLines: 1,
                                              overflow: TextOverflow.visible,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                height: 100,
                              )),
                    ),
                  );
                } else {
                  return const Center(
                      child: Text(
                    'خطا در ارتباط',
                    style: TextStyle(fontSize: 40),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<OrderMSTmodle>> getData() async {
    List<OrderMSTmodle> invoicItemGetData = [];
    //try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    int systemId = prefs.getInt('systemId') ?? 0;
    String urlS = prefs.getString('Url') ?? '';
    String url =
        '${urlS}OrderApi/OrderMstList?usrId=$userId&SystemId=$systemId&CustomerId=0&Status=$status&Date=${jalali.year}/${jalali.month}/${jalali.day}';
    http.Response response = await http.get(Uri.parse(url));
    var dataResponse = json.decode(utf8.decode(response.bodyBytes));
    var meta = (dataResponse as Map)["Meta"];
    var data = (dataResponse as Map)["Data"]["result"];
    if (kDebugMode) {
      print(url);
    }
    if (meta['errorCode'] == -1) {
      orderItem.clear();
      for (var dataA in data) {
        var i = OrderMSTmodle(
            dataA['CustName'], dataA['Code'], dataA['Date'], dataA['SumTotal']);
        orderItem.add(i);
        invoicItemGetData.add(i);
      }
      return invoicItemGetData;
    } else {
      return invoicItemGetData;
    }
    //} on SocketException catch (e) {
    //  return invoicItemGetData;
    //}
    //return invoicItemGetData;
    //var dataResponse = json.decode(utf8.decode(response.bodyBytes));
  }
}

BottomNavigationBarItem bottomNavigationBarItem(String label, Icon icon) {
  return BottomNavigationBarItem(
    icon: icon,
    label: label,
    //backgroundColor: Colors.indigoAccent,
  );
}

Widget lat(String title, int index, String Date, int SumTotal, String Code,
    BuildContext context) {
  NumberFormat.NumberFormat myFormat =
      NumberFormat.NumberFormat.decimalPattern('en_us');
  double width = MediaQuery.of(context).size.width;

  return Text('data');
  // return Padding(
  //   padding: const EdgeInsets.all(5.0),
  //   child: Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(9.0),
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text('${index + 1} - ${Code}'),
  //               Text(myFormat.format(SumTotal)),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 15,
  //           ),
  //           Row(
  //             children: [
  //               SizedBox(
  //                 width: width * 0.89,
  //                 child: Text(
  //                   title,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.visible,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}
