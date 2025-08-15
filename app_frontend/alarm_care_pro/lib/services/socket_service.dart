import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import '../providers/patient_vitals_provider.dart';
import '../providers/ventilator_provider.dart';
import '../providers/infusion_pump_provider.dart';
import 'package:flutter/material.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;

  void connect(BuildContext context) {
    _socket = IO.io('http://127.0.0.1:4444', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.onConnect((_) {
      print('Connected to socket server');
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    _socket!.onConnectError((data) {
      print('Connection Error: $data');
    });

    _socket!.onAny((event, data) {
      print('Received event: $event with data: $data');
    });

    _socket!.on('monitor_message', (data) {
      Provider.of<PatientVitalsProvider>(context, listen: false).setVitals(data);
    });

    _socket!.on('bomb1_message', (data) {
      Provider.of<InfusionPumpProvider>(context, listen: false).setData(data);
    });

    _socket!.on('ventilator_message', (data) {
      Provider.of<VentilatorProvider>(context, listen: false).setData(data);
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
