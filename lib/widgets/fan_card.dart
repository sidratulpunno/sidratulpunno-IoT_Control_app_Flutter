import 'package:flutter/material.dart';

class FanCard extends StatefulWidget {
  final String deviceName;
  final bool initialStatus;
  final int initialSpeed;
  final Function(bool) onToggle;
  final Function(int) onSpeedChange;

  FanCard({
    required this.deviceName,
    required this.initialStatus,
    required this.initialSpeed,
    required this.onToggle,
    required this.onSpeedChange,
  });

  @override
  _FanCardState createState() => _FanCardState();
}

class _FanCardState extends State<FanCard> {
  bool isOn=false;
  int speed=0;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialStatus;
    speed = widget.initialSpeed;
  }

  void toggleSwitch(bool value) {
    setState(() {
      isOn = value;
    });
    widget.onToggle(value);
  }

  void updateSpeed(double value) {
    setState(() {
      speed = value.toInt();
    });
    widget.onSpeedChange(speed);
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
            Icon(Icons.toys, color: isOn ? Colors.blue : Colors.grey, size: 40),
            Text(widget.deviceName),
            Switch(value: isOn, onChanged: toggleSwitch),
            Text("Speed: $speed"),
            Slider(
              value: speed.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: "$speed",
              onChanged: isOn ? updateSpeed : null,
            ),
          ],
        ),
      ),
    );
  }
}
