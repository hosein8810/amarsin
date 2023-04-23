import 'package:amarsin/DataModle.dart';
import 'package:amarsin/Home.dart';
import 'package:amarsin/clearbookModel.dart';
import 'package:amarsin/clearbook_show.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class Clearbook extends StatefulWidget {
  final DataModel dataModel;
  const Clearbook({
    super.key,
    required this.dataModel,
  });

  @override
  State<Clearbook> createState() => _ClearbookState(dataModel);
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class _ClearbookState extends State<Clearbook> {
  final DataModel dataModel;
  int nou = 0;
  List<ClearbookModle> clearbookLis = [
    ClearbookModle(
        name: 'کلربوک مکمل', icon: 'assets/drawable-hdpi/Rectanglemocamel.png'),
    ClearbookModle(
        name: 'کلربوک بهداشتی', icon: 'assets/drawable-hdpi/Rectangle.png'),
    ClearbookModle(name: 'کلربوک گیاهی', icon: 'assets/drawable-hdpi/plant.png')
  ];
  List<ClearbookPersonalModle> clearbookpPersonalLis = [
    ClearbookPersonalModle(
        name: 'کلربوک شخصی1',
        icon: 'assets/drawable-hdpi/Rectanglemocamel.png'),
    ClearbookPersonalModle(
        name: 'کلربوک شخصی2', icon: 'assets/drawable-hdpi/Rectangle.png'),
    ClearbookPersonalModle(
        name: 'کلربوک شخصی3', icon: 'assets/drawable-hdpi/plant.png')
  ];
  bool specialPart = true;
  Color myColor = Colors.tealAccent;
  _ClearbookState(this.dataModel);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    MaterialStateProperty<Color> materialStateProperty =
        MaterialStateProperty.all(const Color.fromRGBO(243, 39, 82, 1));
    MaterialStateProperty<RoundedRectangleBorder> materialStatePropertyshep =
        MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.red)));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('کلربوک'),
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
                onPressed: openAlertBox,
                icon: const Icon(Icons.add_circle_outline))
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'کلربوک های اماده',
                  style: TextStyle(fontSize: 33),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 80.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Image.network(
                                clearbookLis[index].icon,
                                height: width * 0.2 < 64 ? width * 0.2 : 64,
                                width: width * 0.2 < 64 ? width * 0.2 : 64,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: materialStateProperty,
                              shape: materialStatePropertyshep),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ClearbookShow()));
                          },
                          label: Text(
                            clearbookLis[index].name,
                            style: TextStyle(
                                fontSize:
                                    width * 0.05 < 33 ? width * 0.05 : 33),
                          )),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'کلربوک های شخصی',
                  style: TextStyle(fontSize: 33),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 80.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: materialStateProperty,
                            shape: materialStatePropertyshep),
                        onPressed: () {},
                        icon: SizedBox(
                            width: width * 0.4 < 320 ? 320 : width * 0.4,
                            height: 98,
                            child: SizedBox(
                              child: Image.network(
                                clearbookpPersonalLis[index].icon,
                                height: width * 0.2 < 64 ? width * 0.2 : 64,
                                width: width * 0.2 < 64 ? width * 0.2 : 64,
                              ),
                            )),
                        label: Text(
                          clearbookpPersonalLis[index].name,
                          style: TextStyle(
                              fontSize: width * 0.05 < 33 ? width * 0.05 : 33),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  openAlertBox() {
    bool ch = true;

    List itm = ['گیاه اسانس', 'دینه', 'سیمرغ'];
    final List<Animal> animals = [
      Animal(id: 1, name: "Lion"),
      Animal(id: 2, name: "Flamingo"),
      Animal(id: 3, name: "Hippo"),
      Animal(id: 4, name: "Horse"),
      Animal(id: 5, name: "Tiger"),
      Animal(id: 6, name: "Penguin"),
      Animal(id: 7, name: "Spider"),
      Animal(id: 8, name: "Snake"),
      Animal(id: 9, name: "Bear"),
      Animal(id: 10, name: "Beaver"),
      Animal(id: 11, name: "Cat"),
      Animal(id: 12, name: "Fish"),
      Animal(id: 13, name: "Rabbit"),
      Animal(id: 14, name: "Mouse"),
      Animal(id: 15, name: "Dog"),
      Animal(id: 16, name: "Zebra"),
      Animal(id: 17, name: "Cow"),
      Animal(id: 18, name: "Frog"),
      Animal(id: 19, name: "Blue Jay"),
      Animal(id: 20, name: "Moose"),
      Animal(id: 21, name: "Gecko"),
      Animal(id: 22, name: "Kangaroo"),
      Animal(id: 23, name: "Shark"),
      Animal(id: 24, name: "Crocodile"),
      Animal(id: 25, name: "Owl"),
      Animal(id: 26, name: "Dragonfly"),
      Animal(id: 27, name: "Dolphin"),
    ];

    final items = animals
        .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
        .toList();
    //List<Animal> _selectedAnimals = [];
    final List<Animal> selectedAnimals2 = [];

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: StatefulBuilder(builder: (context, setState) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: width * 0.8,
                  height: height * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                          child: Text(
                        'کلربوک جدید',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )),
                      const Divider(),
                      Container(
                        child: Expanded(
                          child: ListView(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.3,
                                    height: 45,
                                    child: Material(
                                      elevation: 0,
                                      borderRadius: BorderRadius.circular(10),
                                      child: const TextField(
                                        //obscureText: true,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            //counterText: "کد فعال ساز",
                                            hintText: "نام",
                                            icon: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(Icons
                                                  .account_circle_outlined),
                                            )),
                                        // controller: userName,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    label: const Text('آیکون'),
                                    icon:
                                        const Icon(Icons.cloud_upload_outlined),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [Text('برند ها')],
                            ),
                            Container(
                              color: const Color.fromARGB(255, 231, 231, 231),
                              child: SizedBox(
                                width: 50,
                                height: height * 0.5 - 20,
                                child: Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: ((context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.arrow_drop_down),
                                                  const Icon(
                                                      Icons.arrow_drop_up),
                                                  Text(itm[index]),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.edit),
                                                      Checkbox(
                                                          value: ch,
                                                          onChanged: (val) {})
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            height: 10,
                                            color: Colors.grey[500],
                                          )
                                        ],
                                      );
                                    }),
                                    itemCount: itm.length,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [Text('بخش ویژه:')],
                            ),
                            Visibility(
                              visible: specialPart,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: (() {
                                      setState(() {
                                        specialPart = !specialPart;
                                      });
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !specialPart,
                              child: Container(
                                // color: const Color.fromARGB(255, 231, 231, 231),
                                child: SizedBox(
                                  width: 50,
                                  height: height * 0.5 - 20,
                                  child: Container(
                                      child: Column(
                                    children: [
                                      SizedBox(
                                        height: 45,
                                        child: Material(
                                          elevation: 0,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: const TextField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            //obscureText: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                //counterText: "کد فعال ساز",
                                                hintText: "عنوان",
                                                icon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Icon(Icons
                                                      .account_circle_outlined),
                                                )),
                                            //controller: userName,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.4),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              MultiSelectBottomSheetField(
                                                initialChildSize: 0.4,
                                                listType:
                                                    MultiSelectListType.CHIP,
                                                searchable: true,
                                                buttonText:
                                                    const Text("برچسب ها"),
                                                //title: const Text("برچسب"),
                                                items: items,
                                                onConfirm: (values) {
                                                  //_selectedAnimals2 = values;
                                                },
                                                chipDisplay:
                                                    MultiSelectChipDisplay(
                                                  onTap: (value) {
                                                    setState(() {
                                                      selectedAnimals2
                                                          .remove(value);
                                                    });
                                                  },
                                                ),
                                              ),
                                              selectedAnimals2.isEmpty
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      // child: const Text(
                                                      //   "Your selected",
                                                      //   style: TextStyle(
                                                      //       color:
                                                      //           Colors.black54),
                                                      // )
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      specialPart =
                                                          !specialPart;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.close_sharp,
                                                    color: Colors.redAccent,
                                                  )),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons
                                                        .check_circle_outline_sharp,
                                                    color: Colors.greenAccent,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            Row(
                              children: const [
                                Text('نوع کلبوک'),
                              ],
                            ),
                            RadioListTile(
                              title: const Text("پیش فرض"),
                              value: 0,
                              groupValue: nou,
                              onChanged: (value) {
                                setState(() {
                                  nou = value!;
                                });
                              },
                            ),
                            RadioListTile(
                              title: const Text("شخصی"),
                              value: 1,
                              groupValue: nou,
                              onChanged: (value) {
                                setState(() {
                                  nou = value!;
                                });
                              },
                            ),
                          ]),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: (width * 0.8) / 2,
                            child: InkWell(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  color: myColor,
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(12.0)),
                                ),
                                child: const Center(
                                    child: Text('ساخت کلربوک جدید')),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (width * 0.8) / 2,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 20.0),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                  ),
                                ),
                                child: const Center(child: Text('انصراف')),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
