import 'package:flutter/material.dart';
import 'mqtt_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MQTTManager mqttManager;
  String message = 'Waiting for message...';

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager(
      server: '192.168.137.1', // Replace with your broker IP
      topic: 'home/Gas',
      clientIdentifier: 'Flutter',
    );
    connectToMQTT();
  }

  void connectToMQTT() async {
    mqttManager.connect();
  }

  @override
  void dispose() {
    mqttManager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MQTT Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Message:',
            ),
            SizedBox(height: 20),
            StreamBuilder<String>(
              stream: mqttManager.messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: TextStyle(fontSize: 20),
                  );
                } else {
                  return Text(
                    'Waiting for message...',
                    style: TextStyle(fontSize: 20),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
