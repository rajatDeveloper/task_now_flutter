import 'package:flutter/material.dart';
import 'package:task_now/app.dart';
import 'package:task_now/core/di/service_locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const TaskNowApp());
}
