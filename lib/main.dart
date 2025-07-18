import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Temperature Alert App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _temperature = 0.0;
  final TextEditingController _temperatureController = TextEditingController();
  final double _highThreshold = 30.0;
  final double _lowThreshold = 10.0;

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  void _checkTemperature(String value) {
    setState(() {
      _temperature = double.tryParse(value) ?? 0.0;
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Temperature Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _temperatureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Temperature',
                border: OutlineInputBorder(),
              ),
              onChanged: _checkTemperature,
            ),
            const SizedBox(height: 20),
            Text(
              'Current Temperature: ${_temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _temperature > _highThreshold
                        ? Colors.red
                        : _temperature < _lowThreshold
                            ? Colors.blue
                            : Colors.black,
                  ),
            ),
            if (_temperature > _highThreshold) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showAlert('Temperature is too high!'),
                child: const Text('Show High Temperature Alert'),
              ),
            ] else if (_temperature < _lowThreshold) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showAlert('Temperature is too low!'),
                child: const Text('Show Low Temperature Alert'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}