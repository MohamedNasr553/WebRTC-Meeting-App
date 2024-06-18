import 'package:connect_cam/src/app_root.dart';
import 'package:flutter/material.dart';

void main() async {
  // ensure that everything in the main method has finished then run MyApp.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppRoot());
}
