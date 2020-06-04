import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:state_gen/annotations.dart';

part 'state.g.dart';

@store
class _AppState with ChangeNotifier {
  @shared bool darkMode = false;

  @shared int counter = 0;
}
