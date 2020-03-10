import 'package:state_gen/annotations.dart';
import 'package:state_gen/src/shared_prefs.dart';
import 'package:state_gen/src/utils.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class StateGenerator extends GeneratorForAnnotation<StateStore> {
  @override
  Future<String> generateForAnnotatedElement(
      Element genericElement, ConstantReader annotation, BuildStep buildStep) async {
    final element = genericElement as ClassElement;
    final fields = element.fields;
    final className = element.name.substring(1);
    final hasSharedPrefs = element.fields.any((field) => field.isShared);

    final variables = fields.map((field) => "${field.type.getDisplayString()} _${field.name};").join('\n');
    final constructorVars = fields.map((field) => "${field.type.getDisplayString()} ${field.name},").join('\n');
    final initializers = fields.map((field) => "this._${field.name} = ${field.name}").join(',\n');

    final sharedPrefsFactory = hasSharedPrefs ? await generateSharedPrefsFactory(element) : "";

    final gettersAndSetters = fields.map((field) {
      final name = field.name;
      final type = field.type.getDisplayString();
      final isList = field.type.isDartCoreList;

      final getter = isList ? 'UnmodifiableListView(this._$name)' : "this._$name";
      final sharedSetter = field.isShared ? generateSharedPrefsSetter(field) : "";

      return """
        $type get $name => $getter;
        set $name($type value) {
          this._$name = value;
          this.notifyListeners();
          $sharedSetter
        }
      """;
    }).join('\n');

    return """
      class $className with ChangeNotifier implements _$className {
        $variables

        $className({
          $constructorVars
        })  : $initializers;
      
        $sharedPrefsFactory

        $gettersAndSetters
      }
    """;
  }
}
