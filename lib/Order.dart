import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as NumberFormat;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/add_invoic.dart';
import 'OrderMSTmodle.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  
  List<OrderMSTmodle> orderItem = [];
  Jalali jalali = Jalali.now();
  String selectedDate = Jalali.now().toJalaliDateTime();
  int _selectedIndex = 0;

  List<Color> colors = [const Color(0x00000050)];
  void _onItemsTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const add_invoic())));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          title: const Text(
            'لیست سفارشات',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TextButton(
                child: Text(
                  '${jalali.year}/${jalali.month}/${jalali.day}',
                  style: const TextStyle(fontSize: 22, color: Colors.black),
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
                      child:
                      //CustomProgressWidget(),

                      ListView.builder(
                        itemCount: orderItem.length,
                        itemBuilder: (context, index) {
                          return lat(
                              orderItem[index].CustName,
                              index,
                              orderItem[index].Date,
                              orderItem[index].SumTotal.toInt(),
                              orderItem[index].Code);
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {}
                  return const Center(child: Text('عدم برقراری ارتباط'));
                })
            // SizedBox(height: 8),
            // _widgetOptions.elementAt((_selectedIndex)),
            //           List<OrderMSTmodle> invoicItems = [];
            // Jalali jalali = Jalali.now();
            // @override
            // Widget build(
            //   BuildContext context,
            // ) {
            //   return Expanded(
            //     child: ListView.builder(
            //       itemCount: invoicItems.length,
            //       itemBuilder: (context, index) {
            //         invoicItems = getData() as List<OrderMSTmodle>;
            //         return lat(invoicItems[index].CustName);
            //       },
            //     ),
            //   );
            // }
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
          '${urlS}OrderApi/OrderMstList?usrId=$userId&SystemId=$systemId&CustomerId=0&Status=0&Date=${jalali.year}/${jalali.month}/${jalali.day}';
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
          var i = OrderMSTmodle(dataA['CustName'], dataA['Code'], dataA['Date'],
              dataA['SumTotal']);
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

Widget lat(String title, int index, String Date, int SumTotal, String Code) {
  NumberFormat.NumberFormat myFormat =
      NumberFormat.NumberFormat.decimalPattern('en_us');
  return Column(
    children: [
      const Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${index + 1} - ${Code}'),
                Text(myFormat.format(SumTotal)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(title),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
