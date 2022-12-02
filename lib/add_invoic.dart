import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class add_invoic extends StatefulWidget {
  const add_invoic({Key? key}) : super(key: key);

  @override
  State<add_invoic> createState() => _add_invoicState();
}

class _add_invoicState extends State<add_invoic> {
  @override
  Widget build(BuildContext context) {
  String selectedDate = Jalali.now().toJalaliDateTime();
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.search_rounded),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          shape: CircularNotchedRectangle(),
          color: Colors.blue,
          child: TextButton(
            onPressed: () async {
              Jalali? picked = await showPersianDatePicker(
               context: context,
               initialDate: Jalali.now(),
               firstDate: Jalali(1385, 8),
               lastDate: Jalali(1450, 9),
               );
               var label = picked?.toJalaliDateTime();
               if (picked != null && picked != selectedDate) {
                            setState(() {
                              label = picked.toJalaliDateTime();
                            });
                          }
              print(label);
            },
            child: Text(
              'ارسال',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        body: Column(children: [
          Container(
            height: 60,
            width: width,
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.qr_code_scanner_sharp,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.qr_code_rounded,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'ثبت سفارشات',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),

          Expanded(child: ListView()),
        ]),
      ),
    );
  }
}
