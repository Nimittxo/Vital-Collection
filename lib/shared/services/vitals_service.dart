import 'dart:io';
import 'dart:convert';

class VitalsService {
  Future<Map<String, dynamic>> readVitals() async {
    try {
      final file = File('..../Python_deepBackEnd/vitals.json'); // adjust the path
      String contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      print('Error reading vitals: $e');
      return {};
    }
  }
}
