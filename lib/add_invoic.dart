import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/customerModle.dart';
//import 'package:untitled2/fancyFab.dart';
//import 'dart:convert';

//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/ProductModle.dart';
import 'package:untitled2/add_invoic_done.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:untitled2/qr.dart';
import 'package:url_launcher/link.dart';

class Add_invoic extends StatefulWidget {
  const Add_invoic({Key? key}) : super(key: key);

  @override
  State<Add_invoic> createState() => _Add_invoicState();
}

List<OrdDtlModle> ordDtlModleList = [];

String customerName = '';
//int customerId = 0;
bool? bottomSheet;
List<CustomerModle> customer = [];
int _customerPage = 1;
int customerId = 0;

class _Add_invoicState extends State<Add_invoic> {
  //int page = 1;

  //final controller = ScrollController();

  final _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  final int _limit = 20;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _posts = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _customerPage += 1; // Increase _page by 1

      try {
        final res = await http
            .get(Uri.parse("$_baseUrl?_page=$_customerPage&_limit=$_limit"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res = await http
          .get(Uri.parse("$_baseUrl?_page=$_customerPage&_limit=$_limit"));
      setState(() {
        _posts = json.decode(res.body);
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  Jalali jalali = Jalali.now();
  bool finish = false;
  Future<void> post() async {
    setState(() {
      finish = true;
    });
    final employeeId = Guid.newGuid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    int systemId = prefs.getInt('systemId') ?? 0;
    String urlS = prefs.getString('Url') ?? '';
    var url = '${urlS}InvoiceApi/InvoiceSave';
    // var k = json.encode(ordDtlModleList);
    // print(k);
    var ordermodlemap = ordDtlModleList.map((e) {
      return {
        "PId": e.pId.toString(),
        "Cnt": e.cnt.toString(),
        "OfferCnt": e.offer.toString(),
        "Cost": e.cost.toString()
      };
    }).toList();
    String ordermodlej = json.encode(ordermodlemap);
    print(ordermodlej);
    var response = await http.post(Uri.parse(url), body: {
      "Id": '0',
      "UsrId": userId.toString(),
      "Acc_System": systemId.toString(),
      "Exp": '',
      "Date": '${jalali.year}/${jalali.month}/${jalali.day}',
      "SanadKind": '5',
      "CustomerId": customerId.toString(),
      "GUID": employeeId.toString(),
      "InvoiceDtls": customer.toString(),
      "InvoiceDtls": ordermodlej,
    });
    print(response.body);
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['Meta']['errorCode'] == -1) {
      setState(() {
        ordDtlModleList.clear();
        customer.clear();
        customerId = 0;
        jalali = Jalali.now();
        customerName = '';
        productId = 0;
        productName = '';
        products.clear();
      });
      Navigator.pop(context);
      setState(() {
        finish = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded,color: Colors.yellowAccent,),
              SizedBox(width: 5,),
              Text(data['Meta']['message'] == ''
                  ? 'خطا در ارتباط'
                  : data['Meta']['message']),
            ],
          ),
              ));
      setState(() {
        finish = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedDate = Jalali.now().toJalaliDateTime();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: FancyFab(),
        bottomNavigationBar: BottomAppBar(
          // notchMargin: 5,
          // shape: CircularNotchedRectangle(),
          color: Colors.blue,
          child: TextButton(
            onPressed: () {
              setState(() {
                post();
              });
            },
            child: finish
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'ارسال',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.replay_sharp),
            )
          ],
          title: Text('ثبت سفارش'),
        ),
        body: Column(children: [
          TextButton(
              child: Text(
                '${jalali.year}/${jalali.month}/${jalali.day}',
                style: TextStyle(fontSize: 22, color: Colors.black),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Material(
              elevation: 0,
              child: SizedBox(
                height: 50,
                width: width,
                child: InkWell(
                  onTap: () {
                    bottomSheet = true;
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        builder: (context) {
                          customer.clear();
                          return SizedBox(
                              height: height - 50, child: kharidar());
                        }).then((customerModl) {
                      setState(() {
                        productName = customerModl.name;
                        customerId = customerModl.id;
                      });
                    });
                    //print('objecttttttttttttttttttttttttttttttttttttt');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'خریدار',
                              style: TextStyle(fontSize: 25),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 20,
                              width: 3,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: (width / 3) * 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  customerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Row(
                  children: [
                    Text(
                      'وضعیت',
                      style: TextStyle(fontSize: 18),
                    ),
                    Link(
                      target: LinkTarget.defaultTarget,
                      uri: Uri.parse('http://dotis.ir/'),
                      builder: (context, followLink) => ElevatedButton(
                          onPressed: followLink, child: Text('-')),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: ordDtlModleList.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        //Divider(),
                        Row(
                          children: [
                            SizedBox(
                                width: width *0.74,
                                child: Text(
                                  ordDtlModleList[index].pName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                )),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    ordDtlModleList.removeWhere((element) =>
                                        ordDtlModleList[index] == element);
                                  });
                                },
                                child: Icon(Icons.delete)),
                          ],
                        ),
                        Row(
                          children: [
                            Text('تعداد ${ordDtlModleList[index].cnt.toString()}'),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Text('آفر ${ordDtlModleList[index].offer.toString()}'),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Text(
                                'مجموع ${(ordDtlModleList[index].cost * ordDtlModleList[index].cnt).toString()}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          )),
        ]),
      ),
    );
  }
}

class kharidar extends StatefulWidget {
  const kharidar({Key? key}) : super(key: key);

  @override
  State<kharidar> createState() => _kharidarState();
}

class _kharidarState extends State<kharidar> {
  final int _limit = 20;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _posts = [];

  String value = '';

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _customerPage += 1;

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int userId = prefs.getInt('userId') ?? 0;
        int systemId = prefs.getInt('systemId') ?? 0;
        String urlS = prefs.getString('Url') ?? '';
        var res = await http.get(Uri.parse(
            "${urlS}CustomerApi/CustomerSearch?search=$value&centerType=1&page=$_customerPage&lastId=0&Acc_System=$systemId&Acc_Year=12&usrId=$userId"));

        var fetchedPosts = json.decode(res.body);
        var meta = (fetchedPosts as Map)["Meta"];
        var data = (fetchedPosts)["Data"]["result"]['SearchResults'];
        if (meta['errorCode'] == -1)
        // ignore: curly_braces_in_flow_control_structures
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            for (var dataA in data) {
              var i = CustomerModle(
                dataA['Id'],
                dataA['Name'],
              );
              //_posts.addAll(fetchedPosts);
              customer.add(i);
              //c.add(i);
            }
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      customer.clear();
      _isFirstLoadRunning = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;
      int systemId = prefs.getInt('systemId') ?? 0;
      String urlS = prefs.getString('Url') ?? '';
      var res = await http.get(Uri.parse(
          "${urlS}CustomerApi/CustomerSearch?search=$value&centerType=1&page=$_customerPage&lastId=0&Acc_System=$systemId&Acc_Year=12&usrId=$userId"));

      var fetchedPosts = json.decode(res.body);
      var meta = (fetchedPosts as Map)["Meta"];
      var data = (fetchedPosts)["Data"]["result"]['SearchResults'];
      if (meta['errorCode'] == -1)
      // ignore: curly_braces_in_flow_control_structures
      if (fetchedPosts.isNotEmpty) {
        //setState(() {
        for (var dataA in data) {
          var i = CustomerModle(
            dataA['Id'],
            dataA['Name'],
          );
          //_posts.addAll(fetchedPosts);
          customer.add(i);
          //c.add(i);
        }
        //});
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width / 5,
          height: 3,
          color: Colors.grey[300],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Expanded(
                      child: TextField(
                    textInputAction: TextInputAction.search,
                    onChanged: (string) {
                      customer.clear();
                      value = string;
                      setState(() {
                        _firstLoad();
                      });
                    },
                    onSubmitted: (value) => setState(() {
                      _firstLoad();
                    }),
                  ))),
              if (_isLoadMoreRunning == true)
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 8),
                  child: const Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      width: 10,
                      height: 10,
                    ),
                  ),
                ),
              if (_isLoadMoreRunning == false)
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 8),
                  child: const Icon(Icons.search_rounded),
                ),
            ],
          ),
        ),
        _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: customer.length,
                  controller: _controller,
                  itemBuilder: (_, index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Material(
                          //color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        customerName = customer[index].name;
                                        customerId = customer[index].id;
                                        bottomSheet = false;
                                      });
                                      Navigator.pop(context, customer[index]);
                                    },
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          customer[index].name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              const Divider()
                            ],
                          ),
                        )),
                  ),
                ),
              ),
        if (_hasNextPage == false)
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 40),
            color: Colors.amber,
            child: const Center(
              child: Text('You have fetched all of the content'),
            ),
          ),
      ],
    );
  }
}

String productName = '';
List<ProductModle> products = [];
int _productPage = 1;
int productId = 0;

class FancyFab extends StatefulWidget {
  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor = ColorTween(
    begin: Colors.blue,
    end: Colors.red,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(
      0.00,
      1.00,
      curve: Curves.linear,
    ),
  ));
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          animate();
        },
        tooltip: 'اسکن چک',
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          animate();
          Navigator.push(context, MaterialPageRoute(builder: (context) => Qr()));
        },
        tooltip: 'اسکن با دوربین',
        child: Icon(Icons.qr_code),
      ),
    );
  }

  Widget inbox() {
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          animate();
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (context) {
                products.clear();
                return SizedBox(height: height - 50, child: Products());
              }).then((value) {
            setState(() {
              ordDtlModleList.add(value);
            });
          });
        },
        tooltip: 'جستجو',
        child: Icon(Icons.search),
      ),
    );
  }

  Widget toggle() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'کالا',
        child: AnimatedIcon(
          icon: AnimatedIcons.search_ellipsis,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    );
  }
}

double cost = 0;

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final int _limit = 20;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _posts = [];

  String value = '';

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _productPage += 1;

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int userId = prefs.getInt('userId') ?? 0;
        int systemId = prefs.getInt('systemId') ?? 0;
        String urlS = prefs.getString('Url') ?? '';
        var res = await http.get(Uri.parse(
            //http://www.ps.dotis.ir/Api/ProductApi/ProductSearch?UsrId=104&Barcode=&page=1&lastId=0&search=&Acc_System=4&Acc_Year=12&hasStock=false
            "${urlS}ProductApi/ProductSearch?UsrId=$userId&Barcode=&page=$_productPage&lastId=0&search=$value&Acc_System=4&Acc_Year=12&hasStock=false"));

        var fetchedPosts = json.decode(res.body);
        var meta = (fetchedPosts as Map)["Meta"];
        var data = (fetchedPosts)["Data"]["result"]['SearchResults'];
        if (meta['errorCode'] == -1)
        // ignore: curly_braces_in_flow_control_structures
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            for (var dataA in data) {
              var i = ProductModle(
                dataA['PId'],
                dataA['PName'],
                dataA['Cost'],
              );
              //_posts.addAll(fetchedPosts);
              products.add(i);
              //c.add(i);
            }
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      products.clear();
      _isFirstLoadRunning = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;
      int systemId = prefs.getInt('systemId') ?? 0;
      String urlS = prefs.getString('Url') ?? '';
      var res = await http.get(Uri.parse(
          "${urlS}ProductApi/ProductSearch?UsrId=$userId&Barcode=&page=$_productPage&lastId=0&search=$value&Acc_System=4&Acc_Year=12&hasStock=false"));

      var fetchedPosts = json.decode(res.body);
      var meta = (fetchedPosts as Map)["Meta"];
      var data = (fetchedPosts)["Data"]["result"]['SearchResults'];
      if (meta['errorCode'] == -1)
      // ignore: curly_braces_in_flow_control_structures
      if (fetchedPosts.isNotEmpty) {
        //setState(() {
        for (var dataA in data) {
          var i = ProductModle(
            dataA['PId'],
            dataA['PName'],
            dataA['Cost'],
          );
          //_posts.addAll(fetchedPosts);
          products.add(i);
          //c.add(i);
        }
        //});
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width / 5,
          height: 3,
          color: Colors.grey[300],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Expanded(
                      child: TextField(
                    textInputAction: TextInputAction.search,
                    onChanged: (string) {
                      products.clear();
                      value = string;
                      setState(() {
                        _firstLoad();
                      });
                    },
                    onSubmitted: (value) => setState(() {
                      _firstLoad();
                    }),
                  ))),
              if (_isLoadMoreRunning == true)
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 8),
                  child: const Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      width: 10,
                      height: 10,
                    ),
                  ),
                ),
              if (_isLoadMoreRunning == false)
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 8),
                  child: const Icon(Icons.search_rounded),
                ),
            ],
          ),
        ),
        _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  controller: _controller,
                  itemBuilder: (_, index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Material(
                          //color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        productName = products[index].name;
                                        productId = products[index].id;
                                        cost = products[index].cost;
                                      });
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          builder: (context) {
                                            products.clear();
                                            return SizedBox(
                                                height: height - 50,
                                                child: const AddProduct());
                                          }).then((value) => {
                                            setState(() {
                                              Navigator.pop(context, value);
                                            })
                                          });

                                      //Navigator.pop(context, customer[index]);
                                    },
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          products[index].name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              Divider()
                            ],
                          ),
                        )),
                  ),
                ),
              ),
        if (_hasNextPage == false)
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 40),
            color: Colors.amber,
            child: const Center(
              child: Text('اخر لیست'),
            ),
          ),
      ],
    );
  }
}

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController costController =
      TextEditingController(text: cost.toInt().toString());
  TextEditingController cntController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: width / 5,
            height: 3,
            color: Colors.grey[300],
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
              child: Text(
            'مشخصات کالا',
            style: TextStyle(fontSize: 20),
          )),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            color: Colors.grey,
            height: 5,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 100, width: 100),
              const SizedBox(
                  height: 100,
                  width: 100,
                  child: Image(image: AssetImage('assets\\NoImage.png'))),
              SizedBox(height: 100, width: 100),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: ListView(
            //scrollDirection: Axis.vertical,
            //shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                      ),
                      child: const Text('مشخصات کالا'),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.grey[350],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'شناسه',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 20,
                                width: 3,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(productId.toString()),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.grey[350],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'نزدیک ترین تاریخ انقضا',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 3,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.grey[350],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'کد کالا',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 3,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(productName.split(':')[0]),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.grey[350],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'نام کالا',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 3,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                              width: (width / 10) * 8 - 10,
                              child: Text(
                                productName.split(':')[1],
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.grey[350],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'تعداد',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 3,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                              width: (width / 10) * 8,
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,

                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                textAlign: TextAlign.center,
                                controller: cntController,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.grey[350],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'آفر',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 3,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                              width: (width / 10) * 8,
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,

                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                textAlign: TextAlign.center,
                                controller: offerController,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.grey[350],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'مبلغ',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 3,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                              width: (width / 10) * 8,
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,

                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                textAlign: TextAlign.center,
                                controller: costController,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'لیست آفر محصول',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.grey[350],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'آفر 2',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 20,
                                width: 3,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              //Text(i.toString()),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.grey[350],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'آفر 1',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 20,
                                width: 3,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              //Text(i.toString()),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.grey[350],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'آفر 4',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 20,
                                width: 3,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              //Text(i.toString()),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.grey[350],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'آفر 3',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 20,
                                width: 3,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              //Text(i.toString()),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
          SizedBox(
              width: width,
              child: ElevatedButton(
                  onPressed: () {
                    OrdDtlModle ordDtlModle = OrdDtlModle(
                        int.parse(cntController.text == ''
                            ? '0'
                            : cntController.text),
                        int.parse(offerController.text == ''
                            ? '0'
                            : offerController.text),
                        int.parse(costController.text == ''
                            ? '0'
                            : costController.text),
                        productId,
                        productName.split(':')[1]);
                    Navigator.pop(context, ordDtlModle);
                  },
                  child: const Text('ثبت کالا')))
        ],
      ),
    );
  }
}
