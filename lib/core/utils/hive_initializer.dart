import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_now/features/task/data/models/task_model.dart';

class HiveInitializer {
  static const String tasksBox = 'tasks_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    
    // Open boxes
    await Hive.openBox<TaskModel>(tasksBox);
  }
  
  static Future<void> close() async {
    await Hive.close();
  }
}
