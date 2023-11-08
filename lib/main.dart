import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPanel(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPanel extends StatefulWidget {
  const MainPanel({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainPanelState createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  // Set up for the port using COM3
  final port = SerialPort('COM3');

  String _annotationValue = '0';

  //String response = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Column(
        children: [
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 255,
                pointers: <GaugePointer>[
                  MarkerPointer(
                    value: double.parse(_annotationValue),
                    onValueChanged: handlePointerValueChanged,
                    enableDragging: true,
                    markerType: MarkerType.circle,
                  )
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      _annotationValue,
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 131, 140, 141)),
                    ),
                    angle: 0,
                    positionFactor: 0,
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: onButtonPressed, child: const Text("Send")),
          //SizedBox(height: 10),
          //ElevatedButton(onPressed: listenForrespon, child: Text("Listen"))
        ],
      ))),
    );
  }

  void handlePointerValueChanged(double value) {
    setState(() {
      final int value0 = value.toInt();
      _annotationValue = '$value0';
    });
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
      print(_annotationValue);
      print(_annotationValue.codeUnits);
      print(Uint8List.fromList(_annotationValue.codeUnits));
      port.write(Uint8List.fromList(_annotationValue.codeUnits));
    } on Exception catch (_) {
      print("error 1");
      port.close();
    }
    port.close();
  }

  /** 
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
      Uint8List data = port.read(8);
      String dataString = String.fromCharCodes(data);
      print(dataString);
      print(port.read(8));
      if (dataString == "1") {
        print("exito");
      }
    } on Exception catch (err, _) {
      print(SerialPort.lastError);
      port.close();
    }
    port.close();
  }
  */
}
