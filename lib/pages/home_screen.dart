import 'dart:convert';

import 'package:connect_cam/api/meeting_api.dart';
import 'package:connect_cam/models/user.model.dart';
import 'package:connect_cam/pages/join_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/FormHelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String meetingId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Call Support",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Form(
        key: formKey,
        child: formUI(context),
      ),
    );
  }

  formUI(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to WebRTC Meeting",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
              context,
              "meetingId",
              "Enter Meeting ID",
              (val) {
                if (val.isEmpty) {
                  return "Meeting Id can't be empty";
                }
                return null;
              },
              (onSaved) {
                meetingId = onSaved;
              },
              borderRadius: 10.0,
              borderFocusColor: Colors.redAccent,
              borderColor: Colors.redAccent,
              hintColor: Colors.grey,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: FormHelper.submitButton(
                    "Join Meeting",
                    () {
                      if (validateAndSave()) {
                        validateMeeting(meetingId, context);
                      }
                    },
                  ),
                ),
                // Flexible(
                //   child: FormHelper.submitButton(
                //     "Start Meeting",
                //         () async {
                //       var response = await startMeeting();
                //       if (response != null) {
                //         final body = json.decode(response.body);
                //         final meetingId = body['data'];
                //         validateMeeting(meetingId, context);
                //       } else {
                //         // Handle the error gracefully, e.g., show a Snackbar or Dialog
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text('Failed to start meeting. Please try again.')),
                //         );
                //       }
                //     },
                //   ),
                // ),
                Flexible(
                  child: FormHelper.submitButton(
                    "Start Meeting",
                    () async {
                      var response = await startMeeting();
                      if (response != null && response.statusCode == 200) {
                        // Successful response
                        try {
                          final body = json.decode(response.body);
                          final meetingId = body['data'];
                          validateMeeting(meetingId, context);
                        } catch (e) {
                          print("Error decoding response: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to start meeting. Please try again.')),
                          );
                        }
                      } else {
                        // Handle HTTP error or null response
                        print("Failed to start meeting. Response: $response");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Failed to start meeting. Please try again.')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void validateMeeting(String meetingId, BuildContext context) async {
    try {
      print("Validating meeting ID: $meetingId");

      http.Response? response = await joinMeeting(meetingId);

      if (response != null && response.statusCode == 200) {
        var data = json.decode(response.body);
        final meetingDetails = MeetingDetail.fromJson(data['data']);
        print("Meeting details: ${meetingDetails.toString()}");
        goToJoinScreen(meetingDetails, context);
      } else {
        print(
            "Invalid meeting ID or failed to join meeting. Status code: ${response?.statusCode}");
        _showInvalidMeetingDialog(context);
      }
    } catch (err) {
      print("Error validating meeting: $err");
      _showInvalidMeetingDialog(context);
    }
  }

  void goToJoinScreen(MeetingDetail meetingDetail, BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => JoinScreen(
          meetingDetail: meetingDetail,
        ),
      ),
    );
  }

  void _showInvalidMeetingDialog(BuildContext context) {
    FormHelper.showSimpleAlertDialog(
        context, "Meeting App", "Invalid Meeting ID", "OK", () {
      Navigator.of(context).pop();
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
