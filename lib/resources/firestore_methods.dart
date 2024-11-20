import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Update a specific device state
  Future<void> updateDeviceState(String deviceName, Map<String, dynamic> state) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        print('Updating device state for $deviceName: $state'); // Debugging
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('devices')
            .doc(deviceName)
            .set(state, SetOptions(merge: true));
        print('Update successful');
      } catch (e) {
        print('Error updating device state: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }


  // Retrieve device state for initialization (optional)
  Future<Map<String, dynamic>?> getDeviceState(String deviceName) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        final doc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('devices')
            .doc(deviceName)
            .get();
        return doc.exists ? doc.data() : null;
      } catch (e) {
        print('Error retrieving device state: $e');
        return null;
      }
    }
    return null;
  }
}
