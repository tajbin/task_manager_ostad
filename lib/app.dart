import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/screens/auth/splash_screen.dart';
import 'package:task_manager_ostad/ui/utility/apps_color.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: _lightTheme(),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppsColor.white,
        filled: true,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.3)
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(double.maxFinite),
          backgroundColor: AppsColor.themeColor,
          foregroundColor: AppsColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey
        )

      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
         foregroundColor: Colors.grey,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500
          )
        )
      )
    );
  }
}
