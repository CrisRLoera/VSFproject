import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final port = SerialPort('COM3');

  //setup Serial

  void writeSerial() {
    port.write(Uint8List.fromList("101001".codeUnits));
  }

  @override
  Widget build(BuildContext context) {
    port.openReadWrite();
    port.config = SerialPortConfig()
      ..baudRate = 115200
      ..bits = 8
      ..parity = SerialPortParity.none
      ..stopBits = 1
      ..setFlowControl(SerialPortFlowControl.none);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                writeSerial();
              },
              child: const Text("Enviar")),
        ),
      ),
    );
  }
}
