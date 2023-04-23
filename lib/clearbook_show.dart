import 'package:flutter/material.dart';

class ClearbookShow extends StatefulWidget {
  const ClearbookShow({super.key});

  @override
  State<ClearbookShow> createState() => _ClearbookShowState();
}

class _ClearbookShowState extends State<ClearbookShow> {
  List names = [
    'کرم سوختگی لاژکس 50 گرمی باریج',
    'شربت اشتها آور کودک باریج',
    'کپسول لاکسافول بلیستر باریج اسنس'
  ];
  List pricel2 = [
    '310,000',
    '310,000',
    '600,000',
  ];
  List pricel3 = ['410,000', '410,000', '950,000'];
  List stok = [20, 5, 0];
  List shel = [0, 0, 22];
  List box = [12, 12, 0];
  List expaire = ['2022/12', '2022/12', '2022/12'];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('کلر بوک'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.display_settings_sharp)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.apps))
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          children: [
            const Text(
              'محصولات ویژه',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 270,
              child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFffffff),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0, // soften the shadow
                                spreadRadius: 1.5, //extend the shadow
                                offset: Offset.zero,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            width: 90,
                                            child: Center(child: stok[index] <= 0 ? Text('ناموجود') : stok[index] > 10 ? Text('موجود') : Text('موجودی محدود'),),
                                            decoration: BoxDecoration(
                                              color:  stok[index] < 0 ? Colors.red : stok[index] > 10 ? Colors.green : Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(names[index],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'قیمت داروخانه : ${pricel2[index]}'),
                                              Text(
                                                  'قیمت مصرف کننده : ${pricel3[index]}'),
                                              Row(
                                                children: [
                                                  Text(
                                                      'تعداد در شل : ${shel[index]}'),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      'تعداد در کارتن : ${box[index]}')
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text('برچسب ها :'),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      'انقضا : ${expaire[index]}')
                                                ],
                                              ),
                                              const Text('مکمل-کودک-ویژه'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 90,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        alignment: Alignment.bottomRight,
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            return const Color.fromARGB(
                                                255,
                                                0,
                                                255,
                                                157); // Use the component's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text('افزودن'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    MaterialButton(
                                      onPressed: () {},
                                      color: const Color.fromARGB(
                                          255, 0, 217, 255),
                                      child: const Text('اطلاعات بیشتر'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
            ),
            const Text(
              'محصولات برند باریج',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: height,
              //width: 100,
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.83,
                  //mainAxisSpacing: 40,
                  crossAxisSpacing: 20,
                  children: List.generate(
                    3,
                    (index) => Column(
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 380,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xFFffffff),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0, // soften the shadow
                                    spreadRadius: 1.5, //extend the shadow
                                    offset: Offset.zero,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            width: 90,
                                            child: Center(child: stok[index] <= 0 ? Text('ناموجود') : stok[index] > 10 ? Text('موجود') : Text('موجودی محدود'),),
                                            decoration: BoxDecoration(
                                              color:  stok[index] <= 0 ? Colors.red : stok[index] > 10 ? Colors.green : Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(names[index],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('تعداد در شل : ${shel[index]}'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('تعداد در کارتن : ${box[index]}')
                                      ],
                                    ),
                                    const Text('برچسب ها :'),
                                    const Text('مکمل-کودک-ویژه'),
                                    Text('قیمت داروخانه : ${pricel2[index]}'),
                                    Text('قیمت مصرف کننده : ${pricel3[index]}'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width / 4,
                                          height: 48,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 0, 255, 157),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(4),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: const Text('افزودن'),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width / 4 - 10,
                                          height: 48,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 0, 217, 255),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(4),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: const Text('اطلاعات بیشتر'),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
