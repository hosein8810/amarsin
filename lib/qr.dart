import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
                      print(event!.code);
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
}
