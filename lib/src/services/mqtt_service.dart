import 'dart:developer';

import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../models/mqtt_model.dart';

class MQTTService {
  MQTTService({
    this.host,
    this.port,
    this.topic,
    this.model,
    this.isMe = false,
  });

  final MQTTModel? model;

  final String? host;

  final int? port;

  final String? topic;

  late MqttBrowserClient _client;

  bool isMe;

  void initializeMQTTClient() {
    _client = MqttBrowserClient(host!, 'flutter-client')
      ..port = port
      ..logging(on: false)
      ..onDisconnected = onDisConnected
      ..onSubscribed = onSubscribed
      ..keepAlivePeriod = 20
      ..onConnected = onConnected;

    _client.websocketProtocols = ['mqtt'];
    _client.setProtocolV311();
    //_client = MqttBrowserClient.withPort(host!, '', port!);

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter-client')
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    print('Connecting....');
    _client.connectionMessage = connMess;
  }

  Future<MqttClientConnectionStatus?> connectMQTT() async {
    try {
      return await _client.connect();
    } on NoConnectionException catch (e) {
      log(e.toString());
      _client.disconnect();
      return null;
    }
  }

  void disConnectMQTT() {
    try {
      _client.disconnect();
    } catch (e) {
      log(e.toString());
    }
  }

  void onConnected() {
    log('Connected');

    try {
      _client.subscribe(topic!, MqttQos.exactlyOnce);
      _client.updates!.listen((dynamic t) {
        final MqttPublishMessage recMess = t[0].payload;
        final message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        print('message id : ${recMess.variableHeader?.messageIdentifier}');
        print('message : $message');
        int id = model!.message.length + 1;
        model!.addMessage(message);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void onDisConnected() {
    log('Disconnected');
  }

  void onSubscribed(String topic) {
    log(topic);
  }
}
