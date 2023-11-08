import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPanel(),
    );
  }
}

class MainPanel extends StatefulWidget {
  const MainPanel({Key? key}) : super(key: key);

  @override
  _MainPanelState createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  final port = SerialPort('COM3');
  String response = "";
  String _annotationValue = '0';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Row(
        children: [
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 255,
                pointers: <GaugePointer>[
                  RangePointer(
                    value: double.parse(_annotationValue),
                    onValueChanged: handlePointerValueChanged,
                    enableDragging: true,
                  )
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Column(
                        children: <Widget>[
                          Text(
                            '$_annotationValue',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Times',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 131, 140, 141)),
                          ),
                          Text(
                            ' %',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Times',
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00A8B5)),
                          )
                        ],
                      ),
                      positionFactor: 0.13,
                      angle: 0)
                ],
              )
            ],
          ),
          ElevatedButton(onPressed: onButtonPressed, child: Text("Send")),
          ElevatedButton(onPressed: listenForrespon, child: Text("Listen"))
        ],
      ))),
    );
  }

  void handlePointerValueChanged(double value) {
    setState(() {
      final int _value = value.toInt();
      _annotationValue = '$_value';
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
}
