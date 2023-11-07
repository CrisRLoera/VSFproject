import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final port = SerialPort('COM3');
  String response = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Row(children: [
          ElevatedButton(
              onPressed: () {
                onButtonPressed();
              },
              child: const Text("Enviar")),
          ElevatedButton(
              onPressed: listenForrespon, child: const Text("Escuchar"))
        ]),
      ),
    ));
  }

  void onButtonPressed() async {
    try {
      port.openReadWrite();
      port.config = SerialPortConfig()
        ..baudRate = 9600
        ..bits = 8
        ..parity = SerialPortParity.none
        ..stopBits = 1
        ..setFlowControl(SerialPortFlowControl.none);
      port.write(Uint8List.fromList("1".codeUnits));
    } on Exception catch (_) {
      print("error 1");
      port.close();
    }
    port.close();
  }

  void listenForrespon() async {
    try {
      port.openRead();
      port.config = SerialPortConfig()
        ..baudRate = 9600
        ..bits = 8
        ..parity = SerialPortParity.none
        ..stopBits = 1
        ..setFlowControl(SerialPortFlowControl.none);
      //print(port.bytesAvailable);
      Uint8List data = port.read(1);
      String dataString = String.fromCharCodes(data);
      //print(dataString);
      //print(port.read(8));
      if (dataString == "1") {
        print("exito");
      }
    } on Exception catch (err, _) {
      print(SerialPort.lastError);
      port.close();
    }
    port.close();
  }
}
