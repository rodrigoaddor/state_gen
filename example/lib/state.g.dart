// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

class AppState with ChangeNotifier implements _AppState {
  bool _darkMode;
  int _counter;

  AppState({
    bool darkMode,
    int counter,
  })  : this._darkMode = darkMode,
        this._counter = counter;

  factory AppState.fromSharedPrefs(SharedPreferences prefs) => AppState(
        darkMode:
            prefs.containsKey('darkMode') ? prefs.getBool('darkMode') : false,
        counter: prefs.containsKey('counter') ? prefs.getInt('counter') : 0,
      );

  bool get darkMode => this._darkMode;
  set darkMode(bool value) {
    this._darkMode = value;
    this.notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('darkMode', value));
  }

  int get counter => this._counter;
  set counter(int value) {
    this._counter = value;
    this.notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setInt('counter', value));
  }
}
