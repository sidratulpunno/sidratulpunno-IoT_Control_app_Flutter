import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoorLockCard extends StatefulWidget {
  final String deviceName;
  final bool initialStatus;
  final Function(bool) onToggle;

  DoorLockCard({
    required this.deviceName,
    required this.initialStatus,
    required this.onToggle,
  });

  @override
  _DoorLockCardState createState() => _DoorLockCardState();
}

class _DoorLockCardState extends State<DoorLockCard> {
  bool isLocked=false;

  @override
  void initState() {
    super.initState();
    isLocked = widget.initialStatus;
  }

  void toggleLock() {
    setState(() {
      isLocked = !isLocked;
    });
    widget.onToggle(isLocked);
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
            Icon(Icons.lock, color: isLocked ? Colors.red : Colors.green, size: 50),
            Text(widget.deviceName),
            ElevatedButton(

              onPressed: toggleLock,
              child: Text(isLocked ? "Unlock" : "Lock",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
