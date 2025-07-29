# TaskNow - Flutter Task Management App

TaskNow is a simple yet powerful task management application built with Flutter, following Clean Architecture principles and using BLoC for state management.

## Features

- Create, read, update, and delete tasks
- Mark tasks as complete/incomplete
- Set due dates for tasks
- View task details
- Responsive design that works on mobile and web
- Local data persistence with Hive
- Clean and intuitive user interface

## Architecture

The app follows Clean Architecture with these layers:

1. **Presentation Layer**: Contains UI components and BLoCs
2. **Domain Layer**: Contains business logic and use cases
3. **Data Layer**: Handles data sources and repositories

### Project Structure

```
lib/
├── core/
│   ├── di/                 # Dependency injection
│   ├── theme/              # App theming
│   └── utils/              # Utility classes and extensions
├── features/
│   └── task/               # Task feature
│       ├── data/           # Data layer
│       │   ├── datasources/# Data sources (local)
│       │   ├── models/     # Data models (Hive)
│       │   └── repositories/# Repository implementations
│       ├── domain/         # Domain layer
│       │   ├── entities/   # Business entities
│       │   ├── repositories/# Repository interfaces
│       │   └── usecases/   # Business logic use cases
│       └── presentation/   # Presentation layer
│           ├── bloc/       # BLoC files
│           ├── pages/      # Screen widgets
│           └── widgets/    # Reusable UI components
├── app.dart               # Main app widget
└── main.dart              # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/task_now_flutter.git
   cd task_now_flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **flutter_bloc**: State management
- **hive**: Local database
- **hive_flutter**: Flutter integration for Hive
- **intl**: Date and time formatting
- **flutter_slidable**: For swipe actions on task items
- **get_it**: Dependency injection

## Key Components

### Task Model

```dart
class MainTask {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Constructor, copyWith, and other methods...
}
```

### BLoC Pattern

The app uses BLoC pattern for state management:

- **TaskEvent**: Defines all possible events (LoadTasks, AddTask, UpdateTask, DeleteTask)
- **TaskState**: Represents different states (TaskInitial, TaskLoading, TaskLoaded, TaskError)
- **TaskBloc**: Handles business logic and state transitions

### Dependency Injection

Using `get_it` for dependency injection:

```dart
final getIt = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  
  // Register services
  getIt.registerLazySingleton(() => Hive.box<TaskModel>('tasks'));
  
  // Register data sources
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(getIt()),
  );
  
  // Register repositories
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt()),
  );
  
  // Register use cases
  getIt.registerLazySingleton(() => GetTasks(getIt()));
  getIt.registerLazySingleton(() => AddTask(getIt()));
  getIt.registerLazySingleton(() => UpdateTask(getIt()));
  getIt.registerLazySingleton(() => DeleteTask(getIt()));
  
  // Register BLoCs
  getIt.registerFactory(() => TaskBloc(getIt(), getIt(), getIt(), getIt()));
}
```

## Screenshots

(Add screenshots of your app here)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter Team for the amazing framework
- BLoC library authors
- Hive for lightweight and fast local storage
