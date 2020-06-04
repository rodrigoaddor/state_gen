import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_gen_example/state.dart';

import 'home.dart';

void main() async {
  //Needed to use SharedPreferences before runApp()
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final state = AppState.fromSharedPrefs(prefs);

  runApp(
    ChangeNotifierProvider.value(
      child: MyApp(),
      value: state,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return MaterialApp(
      title: 'state_gen example',
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
