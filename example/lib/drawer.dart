import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'state.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Drawer(
      child: ListView(
        children: [
          SwitchListTile(
            value: state.darkMode,
            onChanged: (darkModeEnabled) => state.darkMode = darkModeEnabled,
            title: Text('Dark Mode'),
          ),
        ],
      ),
    );
  }
}
