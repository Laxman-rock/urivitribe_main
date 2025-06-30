import 'package:flutter/material.dart';
import 'package:urvitribe_main/route/route_constants.dart';
import 'package:urvitribe_main/route/router.dart' as router;
import 'package:urvitribe_main/theme/app_theme.dart';

import 'utils/shared_pref.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Urvitribe',
      theme: AppTheme.lightTheme(context),
      // Dark theme is inclided in the Full template
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: entryPointScreenRoute,
    );
  }
}
