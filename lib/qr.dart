import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Qr extends StatefulWidget {
  const Qr({Key? key}) : super(key: key);

  @override
  State<Qr> createState() => _QrState();
}

class _QrState extends State<Qr> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  Barcode? event;

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    await controller!.pauseCamera();
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        // notchMargin: 5,
        // shape: CircularNotchedRectangle(),
        color: event != null ? Colors.blue : Colors.grey,
        child: TextButton(
            onPressed: event != null
                ? () {
                    setState(() async {
                      await controller?.stopCamera();
                      print(event!.code!.substring(2,16));
                      Navigator.pop(context);
                    });
                  }
                : null,
            child: Text(
              'تمام',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
      ),
      appBar: AppBar(
        title: Text('اسکن'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrview(context),
          Positioned(
              bottom: 20,
              child: event != null
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white24),
                      child: Text(
                        'اسکن شد',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        maxLines: 3,
                      ),
                    )
                  : Container()),
          Positioned(
              top: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white24),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      icon: FutureBuilder<bool?>(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return snapshot.data!
                                ? Icon(Icons.flash_off)
                                : Icon(Icons.flash_on);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        icon: Icon(Icons.switch_camera)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget buildQrview(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blueAccent,
        borderRadius: 10,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream
        .listen((event) => setState(() => this.event = event));
  }

  Future<void> get() async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;
      int systemId = prefs.getInt('systemId') ?? 0;
      String urlS = prefs.getString('Url') ?? '';
      var res = await http.get(Uri.parse(
          "${urlS}ProductApi/ProductSearch?UsrId=$userId&Barcode=&page=&lastId=0&search=&Acc_System=4&Acc_Year=12&hasStock=false"));

      var fetchedPosts = json.decode(res.body);
      var meta = (fetchedPosts as Map)["Meta"];
      var data = (fetchedPosts)["Data"]["result"]['SearchResults'];
      if (meta['errorCode'] == -1)
      // ignore: curly_braces_in_flow_control_structures
      if (fetchedPosts.isNotEmpty) {
        //setState(() {
        for (var dataA in data) {
          // var i = ProductModle(
          //   dataA['PId'],
          //   dataA['PName'],
          //   dataA['Cost'],
          // );
          //_posts.addAll(fetchedPosts);
          //products.add(i);
          //c.add(i);
        }
        //});
      } else {
        setState(() {
         // _hasNextPage = false;
        });
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }
  }
}
