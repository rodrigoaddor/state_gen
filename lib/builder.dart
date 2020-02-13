import 'package:state_gen/src/state.dart';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder stateBuilder(BuilderOptions options) =>
    SharedPartBuilder([StateGenerator()], 'state');