import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ACCard extends StatefulWidget {
  final String deviceName;
  final bool initialStatus;
  final double initialTemperature;
  final Function(bool) onToggle;
  final Function(double) onTemperatureChange;

  const ACCard({
    required this.deviceName,
    required this.initialStatus,
    required this.initialTemperature,
    required this.onToggle,
    required this.onTemperatureChange,
  });

  @override
  _ACCardState createState() => _ACCardState();
}

class _ACCardState extends State<ACCard> {
  bool isOn = false;
  double temperature = 0;

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
    return SizedBox(
      width: 150, // Set the desired width
      height: 200, // Set the desired height
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.ac_unit, color: isOn ? Colors.blue : Colors.grey, size: 24), // Adjusted icon size
              SizedBox(height: 8),
              Text(
                widget.deviceName,
                style: TextStyle(fontSize: 14), // Adjusted text size
              ),
              SizedBox(height: 8),
              Switch(value: isOn, onChanged: toggleSwitch),
              SizedBox(height: 8),
              Text("Temp: ${temperature.toStringAsFixed(1)}°C",
                  style: TextStyle(fontSize: 12)), // Adjusted text size
              Slider(
                value: temperature,
                min: 16,
                max: 30,
                divisions: 14,
                label: "${temperature.toStringAsFixed(1)}°C",
                onChanged: isOn ? updateTemperature : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
