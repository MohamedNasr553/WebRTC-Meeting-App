import 'dart:convert';

import 'package:connect_cam/utils/user.utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

String MEETING_API_URL = "http://10.0.2.2:5000/api/meeting"; // for Android Emulator

var client = http.Client();

// Future<http.Response?> startMeeting() async {
//   Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
//
//   var userId = await loadUserId();
//
//   var response = await client.post(
//     Uri.parse('$MEETING_API_URL/start'),
//     headers: requestHeaders,
//     body: jsonEncode({
//       'hostId': userId,
//       'hostName': '',
//     }),
//   );
//
//   print("Response status: ${response.statusCode}");
//   print("Response body: ${response.body}");
//
//   (response.statusCode == 200) ? response : null;
// }

Future<http.Response?> startMeeting() async {
  try {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var userId = await loadUserId();

    var response = await client.post(
      Uri.parse('$MEETING_API_URL/start'),
      headers: requestHeaders,
      body: jsonEncode({
        'hostId': userId,
        'hostName': '',
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return response; // Return the response object if status code is 200
    } else {
      print("Failed to start meeting. Status code: ${response.statusCode}");
      return null; // Return null in case of other status codes
    }
  } catch (e) {
    print("Error starting meeting: $e");
    return null; // Return null in case of exceptions
  }
}

Future<http.Response?> joinMeeting(String meetingId) async {
  try {
    var url = Uri.parse('$MEETING_API_URL/join?meetingId=$meetingId');
    var response = await http.get(url);

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 400) {
      return response;
    } else {
      print("Invalid meeting ID or failed to join meeting. Status code: ${response.statusCode}");
      throw Exception('Failed to join meeting');
    }
  } catch (e) {
    print("Error joining meeting: $e");
    throw Exception('Failed to join meeting');
  }
}

// Future<http.Response?> joinMeeting(String meetingId) async {
//   var response =
//       await http.get(Uri.parse('$MEETING_API_URL/join?meetingId=$meetingId'));
//
//   print("Response status: ${response.statusCode}");
//   print("Response body: ${response.body}");
//
//   (response.statusCode >= 200 && response.statusCode < 400)
//       ? response
//       : UnsupportedError('Not a valid meeting');
// }
