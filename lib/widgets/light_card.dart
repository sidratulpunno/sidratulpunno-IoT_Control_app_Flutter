import 'package:flutter/material.dart';

class LightCard extends StatefulWidget {
  final String deviceName;
  final bool initialStatus;
  final Function(bool) onToggle;

  LightCard({required this.deviceName, required this.initialStatus, required this.onToggle});

  @override
  _LightCardState createState() => _LightCardState();
}

class _LightCardState extends State<LightCard> {
  bool isOn=false;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialStatus;
  }

  void toggleSwitch(bool value) {
    setState(() {
      isOn = value;
    });
    widget.onToggle(value);
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
            Icon(Icons.lightbulb, color: isOn ? Colors.yellow : Colors.grey, size: 40),
            Text(widget.deviceName),
            Switch(value: isOn, onChanged: toggleSwitch),
          ],
        ),
      ),
    );
  }
}
