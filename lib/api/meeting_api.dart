import 'dart:convert';

import 'package:connect_cam/utils/user.utils.dart';
import 'package:http/http.dart' as http;

String MEETING_API_URL = "";
var client = http.Client();

Future<http.Response?> startMeeting() async {
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

  (response.statusCode == 200) ? response : null;
}

Future<http.Response?> joinMeeting(String meetingId) async {
  var response =
      await http.get(Uri.parse('$MEETING_API_URL/join?meetingId=$meetingId'));

  (response.statusCode >= 200 && response.statusCode < 400)
      ? response
      : UnsupportedError('Not a valid meeting');
}
