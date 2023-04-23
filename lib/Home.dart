import 'dart:convert';
import 'dart:io';

import 'package:amarsin/clearbook.dart';
import 'package:amarsin/invoice.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:untitled2/Buttons.dart';
import 'package:amarsin/DataModle.dart';
import 'package:amarsin/LoginDataModle.dart';
import 'package:amarsin/Order.dart';
import 'package:amarsin/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:amarsin/returned%20report.dart';
import 'package:amarsin/routePage.dart';
import 'package:amarsin/scan.dart';

class MainPage extends StatelessWidget {
  final DataModel dataModel;
  MainPage({Key? key, required this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: mainPage(dataModel: dataModel),
      //theme: ThemeData(fontFamily: 'sans_bold'),
    );
  }
}

class mainPage extends StatefulWidget {
  final DataModel dataModel;
  mainPage({
    Key? key,
    required this.dataModel,
  });

  @override
  _MainPageState createState() => _MainPageState(dataModel: dataModel);
}

class _MainPageState extends State<mainPage> {
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
    //!  Key? key,
    required this.dataModel,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return MaterialApp(
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
                body: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.5,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: name.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.of(context)
                                          .push(materialPageRoutelst[index]),
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
                                            borderRadius: BorderRadius.circular(
                                                1000), //<-- SEE HERE
                                          ),
                                          child: Center(
                                            child: Container(
                                              height: width * 0.25,
                                              width: width * 0.25,
                                              padding: const EdgeInsets.all(16),
                                              child: Image.network(
                                                imagelst[index],
                                                height: width * 0.2,
                                                width: width * 0.2,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Text(name[index])
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text(
                          'خطا در ارتباط',
                          style: TextStyle(fontSize: 40),
                        ));
                      }
                    }),
              )),
          theme: ThemeData(fontFamily: 'sans_bold'),
        );
      } else if (constraints.maxWidth <= 1000) {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'sans_bold'),
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
                body: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.5,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: name.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.of(context)
                                          .push(materialPageRoutelst[index]),
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
                                            borderRadius: BorderRadius.circular(
                                                1000), //<-- SEE HERE
                                          ),
                                          child: Center(
                                            child: Container(
                                              height: width * 0.15,
                                              width: width * 0.15,
                                              padding: const EdgeInsets.all(16),
                                              child: Image.network(
                                                imagelst[index],
                                                height: width * 0.2,
                                                width: width * 0.2,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Text(name[index])
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text(
                          'خطا در ارتباط',
                          style: TextStyle(fontSize: 40),
                        ));
                      }
                    }),
              )),
        );
      } else {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'sans_bold'),
          debugShowCheckedModeBanner: false,
          home: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Container(
                    child: Material(
                        elevation: 10, child: drawer(dataModel: dataModel)),
                  ),
                  Container(
                    color: Colors.grey[350],
                    height: MediaQuery.of(context).size.height,
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      child: Scaffold(
                        appBar: AppBar(
                            centerTitle: true,
                            title: Text(
                              'خانه',
                              style: TextStyle(fontSize: 17),
                            )),
                        body: FutureBuilder(
                            future: getData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasData) {
                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 1.5,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: name.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Future.delayed(Duration.zero,
                                                    () {
                                                  Navigator.of(context).push(
                                                      materialPageRoutelst[
                                                          index]);
                                                });
                                              },
                                              child: Card(
                                                  semanticContainer: true,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  //margin: EdgeInsets.all(60),
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                      width: 1,
                                                      color: Colors.blue,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1000), //<-- SEE HERE
                                                  ),
                                                  child: Center(
                                                    child: Container(
                                                      height: width * 0.15,
                                                      width: width * 0.15,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Image.network(
                                                        imagelst[index],
                                                        height: width * 0.2,
                                                        width: width * 0.2,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Text(name[index])
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                    child: Text(
                                  'خطا در ارتباط',
                                  style: TextStyle(fontSize: 40),
                                ));
                              }
                            }),
                      ),
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  bool agen = true;

  Future<List<String>> getData() async {
    List<String> namee = [];
    //try {
    if (agen) {
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
          var loginDataModel = LoginDataModel(meta['errorCode'],
              meta['message'], data['userId'], data['Perms'].split(','));
          if (loginDataModel.errorCode == -1) {
            prefs.setInt('userId', loginDataModel.userId);
            Perms = loginDataModel.perms;
            namee = loginDataModel.perms;
            agen = false;
            perms();
          } else {}
        } else {}
        //return namee;
        //agen = false;
        return namee;
      } else {
        namee = name;
        return namee;
      }
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
    debugPrint(Perms.toString());
    return res;
  }

  void creatnode(String id, String title, String image,
      MaterialPageRoute materialPageRoute) {
    if (hasperm(id)) {
      idlst.add(id);
      name.add(title);
      imagelst.add('assets/drawable-hdpi/' + image);
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
        MaterialPageRoute(
            builder: (
          context,
        ) =>
                Order(
                  dataModel: dataModel,
                )),
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
        MaterialPageRoute(builder: (context) =>  Clearbook(dataModel: dataModel,)),
      );
      creatnode(
        '991050000',
        'کلیر بوک',
        'ic_clearbook.png',
        MaterialPageRoute(builder: (context) => const Scan()),
      );
    }
  }

  Row buttons(String name, BuildContext context, String image,
      MaterialPageRoute materialPageRoute) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  Future.delayed(Duration.zero, () {
                    Navigator.push(context, materialPageRoute);
                  });
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
                    child: Image.asset(
                      image,
                      height: 70,
                      width: 70,
                    ),
                  ),
                ),
              ),
            ),
            Text(name,
                style: const TextStyle(fontSize: 18, color: Color(0xFF4E4E4E))),
          ],
        ),
        //Container(color: Colors.blue,width: 10,height: 10,)
      ],
    );
  }
}
