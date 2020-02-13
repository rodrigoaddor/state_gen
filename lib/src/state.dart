import 'package:state_gen/annotations.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

const sharedTypes = const {
  'bool': 'Bool',
  'double': 'Double',
  'int': 'Int',
  'List<String>': 'StringList',
  'String': 'String',
};

bool isEnum(FieldElement field) => field.type.element.runtimeType.toString() == 'EnumElementImpl';
final sharedChecker = TypeChecker.fromRuntime(Shared.runtimeType);

class StateGenerator extends GeneratorForAnnotation<StateStore> {
  @override
  String generateForAnnotatedElement(Element genericElement, ConstantReader annotation, BuildStep buildStep) {
    String output = '';
    final element = genericElement as ClassElement;
    final className = element.name.substring(1);
    final hasSharedPrefs = annotation.read('hasSharedPrefs').boolValue;

    output += "class $className with ChangeNotifier implements _$className {" +
        element.fields
            .map((field) => "${field.type.getDisplayString()} _${field.name};")
            .toList(growable: false)
            .join() +
        "$className({" +
        element.fields
            .map((field) => "${field.type.getDisplayString()} ${field.name}")
            .toList(growable: false)
            .join(',') +
        "}) :" +
        element.fields.map((field) => "this._${field.name} = ${field.name}").toList(growable: false).join(',') +
        ";";

    if (hasSharedPrefs)
      output += "factory $className.fromSharedPrefs(SharedPreferences prefs) => $className(" +
          element.fields.map((field) {
            final name = field.name;
            final type = field.type.getDisplayString();
            if (sharedTypes.keys.contains(type)) {
              return "$name: prefs.get${sharedTypes[type]}('$name')}";
            } else if (isEnum(field)) {
              return "$name: $type.values[prefs.getInt('$name')]";
            } else {
              return "$name: null /*UNKNOWN TYPE: $type*/";
            }
          }).toList(growable: false).join(',') +
          ");";

    element.fields.forEach((field) {
      final name = field.name;
      final type = field.type.getDisplayString();

      output += "$type get $name => this._$name;"
          "set $name($type value) {"
          "this._$name = value;"
          "this.notifyListeners();";

      if (sharedChecker.hasAnnotationOfExact(field)) {
        if (sharedTypes.keys.contains(type)) {
          output += "SharedPreferences.getInstance().then((prefs) => prefs.set${sharedTypes[type]}('$name', value));";
        } else if (isEnum(field)) {
          output += "SharedPreferences.getInstance().then((prefs) => prefs.setInt('$name', value.index));";
        } else {
          print('Unknown type for SharedPreferences: $type (in field $name)');
        }
      }

      output += "}";
    });

    output += "}";
    return output;
  }
}
