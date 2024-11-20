import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeyserCard extends StatefulWidget {
  final String deviceName;
  final bool initialStatus;
  final double initialTemperature;
  final Function(bool) onToggle;
  final Function(double) onTemperatureChange;

  GeyserCard({
    required this.deviceName,
    required this.initialStatus,
    required this.initialTemperature,
    required this.onToggle,
    required this.onTemperatureChange,
  });

  @override
  _GeyserCardState createState() => _GeyserCardState();
}

class _GeyserCardState extends State<GeyserCard> {
  bool isOn=false;
  double temperature=0;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialStatus;
    temperature = widget.initialTemperature;
  }

  void toggleSwitch(bool value) {
    setState(() {
      isOn = value;
    });
    widget.onToggle(value);
  }

  void updateTemperature(double value) {
    setState(() {
      temperature = value;
    });
    widget.onTemperatureChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hot_tub, color: isOn ? Colors.orange : Colors.grey, size: 40),
            Text(widget.deviceName),
            Switch(value: isOn, onChanged: toggleSwitch),
            Text("Temperature: ${temperature.toStringAsFixed(1)}°C"),
            Slider(
              value: temperature,
              min: 30,
              max: 70,
              divisions: 8,
              label: "${temperature.toStringAsFixed(1)}°C",
              onChanged: isOn ? updateTemperature : null,
            ),
          ],
        ),
      ),
    );
  }
}
