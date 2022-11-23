
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/Buttons.dart';
import 'package:untitled2/DataModle.dart';
import 'package:untitled2/LoginDataModle.dart';
import 'package:untitled2/Order.dart';
import 'package:untitled2/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/scan.dart';

class MainPage extends StatefulWidget{
  final DataModel dataModel;
  MainPage({Key? key, required this.dataModel,});

  @override
  _MainPageState createState() => _MainPageState(dataModel: dataModel);
}

class _MainPageState extends State<MainPage> {
  List<String> Perms = [];
  List<String> idlst =[];
  List<String> name = [];
  List<String> imagelst = [];
  List<MaterialPageRoute> materialPageRoutelst= [];
  Jalali jalali = Jalali.now();
  @override
  void initState() {
    super.initState();
    getData();
    print('${jalali.year}/${jalali.month}/${jalali.day}');
  }
  final DataModel dataModel;


  _MainPageState({Key? key, required this.dataModel,});



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
                drawer: drawer(dataModel: dataModel,),
                body: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.5,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: name.length,
                        itemBuilder: (context, index) {
                          return buttons(name[index], context, imagelst[index],materialPageRoutelst[index]);
                        },
                      ),
                    ),
                  ],
                ))),
        theme: ThemeData(fontFamily: 'sans_bold'),
      ),
    );
  }
  void getData() async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userName = prefs.getString('userName', ) ?? '';
      String pass = prefs.getString('pass',) ?? '';
      var url = '${dataModel.Url}UserApi/login?_userName=${userName}&_pass=${pass}&player_id=0&_customerTyp=9';
      http.Response response = await http.get(Uri.parse(url));
      setState(() {
        var dataResponse = json.decode(utf8.decode(response.bodyBytes));
        var meta = (dataResponse as Map)["Meta"];
        var data = (dataResponse as Map)["Data"]["result"];
        if(meta['errorCode'] == -1){
          var loginDataModel = LoginDataModel(
              meta['errorCode'], meta['message'], data['Perms'].split(','));
          if (loginDataModel.errorCode == -1) {
            Perms = loginDataModel.perms;
            perms();
          } else {

          }
        }else {

        }
      });

    }on SocketException catch (e) {

    }

    //var dataResponse = json.decode(utf8.decode(response.bodyBytes));
  }
  bool hasperm(String id){
    bool res = false;
    for(String index in Perms){
      if(id == index){
        res = true;
      }
    }
    return res;
  }
  void creatnode(String id,String title,String image,MaterialPageRoute materialPageRoute){
    if (hasperm(id)) {
      idlst.add(id);
      name.add(title);
      imagelst.add('assets\\drawable-hdpi\\' + image);
      materialPageRoutelst.add(materialPageRoute);
    }
  }
void perms(){
    setState(() {
      creatnode('994032998','ویزیت','ic_shopping_basket.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994020000','مالی','ic_calculator.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994030000','بازرگانی','ic_cash_register.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994032995','کارتابل','ic_cartable.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994032400','برگه مسیر','ic_routepage.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994032150','پیش فاکتور خرید','ic_invoice.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994050200','دریافت','ic_pay.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('992010000','رسید های موقت','ic_receipt.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('991030000','مشتریان','ic_customers.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994032998','کاتالوگ','ic_products.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994050300','ثبت سفارش','ic_baskets.png',MaterialPageRoute(builder: (context) => const Order()),);
      creatnode('994050330','ثبت مرجوعی','ic_returned_report.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994050400','مشخصات کالا','ic_product.png',MaterialPageRoute(builder: (context) => const Scan()),);
      creatnode('994051400','گزارش فروش','ic_sales_report.png',MaterialPageRoute(builder: (context) => const Scan()),);

    });


  // for(String index in Perms){
  //   print(I);
  //     if (index == '994032998') {
  //       setState(() {
  //         name.add('ویزیت');
  //         image.add('assets\\drawable-hdpi\\ic_shopping_basket.png',);
  //       });
  //     }
  //   if(index == '994020000'){
  //     setState(() {
  //       name.add('مالی');
  //       image.add('assets\\drawable-hdpi\\ic_calculator.png',);
  //     });
  //
  //   }
  //   if(index == '994030000'){
  //     setState(() {
  //       name.add('بازرگانی');
  //       image.add('assets\\drawable-hdpi\\ic_cash_register.png',);
  //     });
  //
  //   }
  //   if(index == '994032995'){
  //     setState(() {
  //       name.add('کارتابل');
  //       image.add('assets\\drawable-hdpi\\ic_cartable.png',);
  //     });
  //
  //   }
  //   if(index == '994032400'){
  //     setState(() {
  //       name.add('برگه مسیر');
  //       image.add('assets\\drawable-hdpi\\ic_routepage.png',);
  //     });
  //
  //   }
  //   if(index == '994032150'){
  //     setState(() {
  //       name.add('پیش فاکتور خرید');
  //       image.add('assets\\drawable-hdpi\\ic_invoice.png',);
  //     });
  //
  //   }
  //   if(index == '994050200'){
  //     setState(() {
  //       name.add('دریافت');
  //       image.add('assets\\drawable-hdpi\\ic_pay.png',);
  //     });
  //
  //   }
  //   if(index == '992010000'){
  //     setState(() {
  //       name.add('رسید های موقت');
  //       image.add('assets\\drawable-hdpi\\ic_receipt.png',);
  //     });
  //
  //   }
  //   if(index == '991030000'){
  //     setState(() {
  //       name.add('مشتریان');
  //       image.add('assets\\drawable-hdpi\\ic_customers.png',);
  //     });
  //
  //   }
  //   // if(index == '992010000'){
  //   //   setState(() {
  //   //     name.add('کاتالوگ');
  //   //     image.add('assets\\drawable-hdpi\\ic_receipt.png',);
  //   //   });
  //   //
  //   // }
  //   if(index == '994050300'){
  //     setState(() {
  //       name.add('ثبت سفارش');
  //       image.add('assets\\drawable-hdpi\\ic_baskets.png',);
  //     });
  //
  //   }
  //   if(index == '994050330'){
  //     setState(() {
  //       name.add('ثبت مرجوعی');
  //       image.add('assets\\drawable-hdpi\\ic_returned_report.png',);
  //     });
  //
  //   }
  //   if(index == '994050400'){
  //     setState(() {
  //       name.add('مشخصات کالا');
  //       image.add('assets\\drawable-hdpi\\ic_product.png',);
  //     });
  //
  //   }
  //   if(index == '994051400'){
  //     setState(() {
  //       name.add('گزارش فروش');
  //       image.add('assets\\drawable-hdpi\\ic_sales_report.png',);
  //     });
  //
  //   }
  //   I++;
  // }
}
}