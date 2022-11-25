
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Jalali jalali = Jalali.now();
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    before(),
    Record(),
    invoic(),
    Distribution(),
    Delivered(),
  ];
  List<Color> colors=[
    Color(000080)
  ];
  void _onItemsTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'پییش نویس',
                backgroundColor: Colors.indigoAccent,

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'پییش فاکتور',
                backgroundColor: Colors.blue

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'ثبت',
                backgroundColor: Colors.lightBlue

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'توزیع',
                backgroundColor: Colors.lightBlueAccent
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'تحویل شده',
              backgroundColor: Colors.cyanAccent
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemsTap,
          //backgroundColor: Colors.red,
          unselectedItemColor: Colors.grey,
        ),
        body: Column(
          children: [
            Container(
              height: 60,
              width: width,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: 35,),
                    onPressed: () {},
                  ),
                  Center(child: Text('لیست سفارشات',
                    style: TextStyle(color: Colors.white, fontSize: 20),),),
                  Directionality(
                      textDirection: TextDirection.ltr,
                      child: IconButton(onPressed: () {
                        Navigator.pop(context);
                      },
                        icon: Icon(
                          Icons.arrow_back, color: Colors.white, size: 30,),)),
                ],
              ),
            ),
            TextButton(child: Text(
              '${jalali.year}/${jalali.month}/${jalali.day}',
              style: TextStyle(fontSize: 22, color: Colors.black),),
                onPressed: () {}),
            //SizedBox(height: 8),
            _widgetOptions.elementAt((_selectedIndex)),
          ],
        ),
      ),
    );
  }
}

class lat extends StatelessWidget {
  const lat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('data'),
                    Text('data'),
                  ],),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text('data'),
                  ],
                ),
                SizedBox(height: 10,),
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


class before extends StatelessWidget {
  const before({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index){
          return lat();
        },
      ),);
  }
}

class invoic extends StatelessWidget {
  const invoic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index){
          return lat();
        },
      ),);
  }
}

class Record extends StatelessWidget {
  const Record({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index){
          return lat();
        },
      ),);
  }
}

class Distribution extends StatelessWidget {
  const Distribution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index){
          return lat();
        },
      ),);
  }
}

class Delivered extends StatelessWidget {
  const Delivered({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index){
          return lat();
        },
      ),);
  }
}
