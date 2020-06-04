import 'package:flutter/material.dart';

import 'package:state_gen_example/state.dart';
import 'package:provider/provider.dart';

import 'drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: Text('state_gen example')),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter: ${state.counter}',
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Close and open or restart the app\nto see that the value is saved',
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => state.counter++,
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => state.counter--,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
