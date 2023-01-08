import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:untitled2/Buttons.dart';
import 'package:untitled2/DataModle.dart';
import 'package:untitled2/LoginDataModle.dart';
import 'package:untitled2/Order.dart';
import 'package:untitled2/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/invoice.dart';
import 'package:untitled2/returned%20report.dart';
import 'package:untitled2/routePage.dart';
import 'package:untitled2/scan.dart';

class MainPage extends StatefulWidget {
  final DataModel dataModel;
  MainPage({
    Key? key,
    required this.dataModel,
  });

  @override
  _MainPageState createState() => _MainPageState(dataModel: dataModel);
}

class _MainPageState extends State<MainPage> {
  List<String> Perms = [];
  List<String> idlst = [];
  List<String> name = [];
  List<String> imagelst = [];
  List<MaterialPageRoute> materialPageRoutelst = [];
  Jalali jalali = Jalali.now();

  @override
  void initState() {
    super.initState();
    getData();
    print('${jalali.year}/${jalali.month}/${jalali.day}');
  }

  final DataModel dataModel;

  _MainPageState({
    Key? key,
    required this.dataModel,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                      'خانه',
                      style: TextStyle(fontSize: 17),
                    )),
                drawer: drawer(
                  dataModel: dataModel,
                ),
                body: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            return Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1.35,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: name.length,
                                itemBuilder: (context, index) {
                                  // return buttons(
                                  //     name[index],
                                  //     context,
                                  //     imagelst[index],
                                  //     materialPageRoutelst[index]);
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Future.delayed(Duration.zero, () {
                                                Navigator.of(context)
                                                    .push(materialPageRoutelst[
                                                        index])
                                                    .then((value) {
                                                  setState(() {
                                                    materialPageRoutelst
                                                        .clear();
                                                    imagelst.clear();
                                                    name.clear();
                                                    idlst.clear();
                                                    perm = true;
                                                  });
                                                });
                                              });
                                            },
                                            child: Card(
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              //margin: EdgeInsets.all(60),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  width: 1,
                                                  color: Colors.blue,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  1000000,
                                                ), //<-- SEE HERE
                                              ),
                                              child: Center(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Expanded(
                                                      child: Image.asset(
                                                    imagelst[index],
                                                    height: 70,
                                                    width: 70,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                          //SizedBox(height: 2,),
                                          Text(name[index],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFF4E4E4E))),
                                        ],
                                      ),
                                      //Container(color: Colors.blue,width: 10,height: 10,)
                                    ],
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                                child: Text(
                              'خطا در ارتباط',
                              style: TextStyle(fontSize: 40),
                            ));
                          }
                        }),
                    // Expanded(
                    //   child: GridView.builder(
                    //     gridDelegate:
                    //         const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       crossAxisSpacing: 12,
                    //       childAspectRatio: 1.5,
                    //       mainAxisSpacing: 20,
                    //     ),
                    //     itemCount: name.length,
                    //     itemBuilder: (context, index) {
                    //       return buttons(name[index], context, imagelst[index],
                    //           materialPageRoutelst[index]);
                    //     },
                    //   ),
                    // ),
                  ],
                ))),
        theme: ThemeData(fontFamily: 'sans_bold'),
      ),
    );
  }

  Future<List<String>> getData() async {
    List<String> namee = [];
    //try {
    if (name.length == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userName = prefs.getString(
            'userName',
          ) ??
          '';
      String pass = prefs.getString(
            'pass',
          ) ??
          '';
      String urlS = prefs.getString('Url') ?? '';
      var url =
          '${urlS}UserApi/login?_userName=${userName}&_pass=${pass}&player_id=0&_customerTyp=9';
      http.Response response = await http.get(Uri.parse(url));
      var dataResponse = json.decode(utf8.decode(response.bodyBytes));
      var meta = (dataResponse as Map)["Meta"];
      var data = (dataResponse as Map)["Data"]["result"];
      if (meta['errorCode'] == -1) {
        var loginDataModel = LoginDataModel(meta['errorCode'], meta['message'],
            data['userId'], data['Perms'].split(','));
        if (loginDataModel.errorCode == -1) {
          prefs.setInt('userId', loginDataModel.userId);
          Perms = loginDataModel.perms;
          namee = loginDataModel.perms;
          perms();
        } else {}
      } else {}
      //return namee;
      return namee;
    } else {
      namee = name;
      return namee;
    }
    //} on SocketException catch (e) {
    //return namee;
    //}
    //return namee;
    //var dataResponse = json.decode(utf8.decode(response.bodyBytes));
  }

  bool hasperm(String id) {
    bool res = false;
    for (String index in Perms) {
      if (id == index) {
        res = true;
      }
    }
    return res;
  }

  void creatnode(String id, String title, String image,
      MaterialPageRoute materialPageRoute) {
    if (hasperm(id)) {
      idlst.add(id);
      name.add(title);
      imagelst.add('assets\\drawable-hdpi\\' + image);
      materialPageRoutelst.add(materialPageRoute);
    }
  }

  bool perm = true;
  void perms() {
    if (perm) {
      perm = false;
      creatnode(
        '994032998',
        'ویزیت',
        'ic_shopping_basket.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '994020000',
        'مالی',
        'ic_calculator.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '994030000',
        'بازرگانی',
        'ic_cash_register.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '994032995',
        'کارتابل',
        'ic_cartable.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '994032400',
        'برگه مسیر',
        'ic_routepage.png',
        MaterialPageRoute(builder: (context) => const routePage()),
      );
      creatnode(
        '994032150',
        'پیش فاکتور خرید',
        'ic_invoice.png',
        MaterialPageRoute(builder: (context) => const invoice()),
      );
      creatnode(
        '994050200',
        'دریافت',
        'ic_pay.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '992010000',
        'رسید های موقت',
        'ic_receipt.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '991030000',
        'مشتریان',
        'ic_customers.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '994032998',
        'کاتالوگ',
        'ic_products.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '994050300',
        'ثبت سفارش',
        'ic_baskets.png',
        MaterialPageRoute(builder: (context) => const Order()),
      );
      creatnode(
        '994050330',
        'ثبت مرجوعی',
        'ic_returned_report.png',
        MaterialPageRoute(builder: (context) => const returned_report()),
      );
      creatnode(
        '994050400',
        'مشخصات کالا',
        'ic_product.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
      creatnode(
        '994051400',
        'گزارش فروش',
        'ic_sales_report.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
    }
  }

  void onn() {}

  Widget buttons(String name, BuildContext context, String image,
      MaterialPageRoute materialPageRoute) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).push(materialPageRoute);
                });
              },
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                //margin: EdgeInsets.all(60),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(
                    1000000,
                  ), //<-- SEE HERE
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Expanded(
                        child: Image.asset(
                      image,
                      height: 70,
                      width: 70,
                    )),
                  ),
                ),
              ),
            ),
            //SizedBox(height: 2,),
            Text(name,
                style: const TextStyle(fontSize: 18, color: Color(0xFF4E4E4E))),
          ],
        ),
        //Container(color: Colors.blue,width: 10,height: 10,)
      ],
    );
  }
}
