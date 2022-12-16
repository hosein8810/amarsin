import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/ProductModle.dart';
import 'package:intl/intl.dart' as NumberFormat;
import 'package:untitled2/add_invoic_done.dart';

String c = '';
bool? bottomSheet;
List<ProductModle> customer = [];
int _page = 1;
int i = 0;

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
                customer.clear();
                return SizedBox(height: height - 50, child: Products());
              }).then((value) {
            setState(() {
              Navigator.pop(context,value);
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

      _page += 1;

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int userId = prefs.getInt('userId') ?? 0;
        int systemId = prefs.getInt('systemId') ?? 0;
        String urlS = prefs.getString('Url') ?? '';
        var res = await http.get(Uri.parse(
            //http://www.ps.dotis.ir/Api/ProductApi/ProductSearch?UsrId=104&Barcode=&page=1&lastId=0&search=&Acc_System=4&Acc_Year=12&hasStock=false
            "${urlS}ProductApi/ProductSearch?UsrId=$userId&Barcode=&page=$_page&lastId=0&search=$value&Acc_System=4&Acc_Year=12&hasStock=false"));

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
          "${urlS}ProductApi/ProductSearch?UsrId=$userId&Barcode=&page=$_page&lastId=0&search=$value&Acc_System=4&Acc_Year=12&hasStock=false"));

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
                                        c = customer[index].name;
                                        i = customer[index].id;
                                        cost = customer[index].cost;
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
                                            customer.clear();
                                            return SizedBox(
                                                height: height - 60,
                                                child: AddProduct());
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
                                          customer[index].name,
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
              child: Text('You have fetched all of the content'),
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
      TextEditingController(text: cost.toString());
  TextEditingController cntController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
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
                              Text(i.toString()),
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
                          Text(c.split(':')[0]),
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
                              width: (width / 10) * 8,
                              child: Text(
                                c.split(':')[1],
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
                        int.parse(cntController.text),
                        int.parse(offerController.text),
                        int.parse(cntController.text),
                        i,
                        c.split(':')[1]);
                    Navigator.pop(context, ordDtlModle);
                  },
                  child: const Text('ثبت کالا')))
        ],
      ),
    );
  }
}
