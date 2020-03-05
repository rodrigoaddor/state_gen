import 'package:state_gen/annotations.dart';
import 'package:state_gen/src/utils.dart';

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

final sharedChecker = TypeChecker.fromRuntime(shared.runtimeType);

class StateGenerator extends GeneratorForAnnotation<StateStore> {
  @override
  Future<String> generateForAnnotatedElement(
      Element genericElement, ConstantReader annotation, BuildStep buildStep) async {
    String output = '';
    final element = genericElement as ClassElement;
    final className = element.name.substring(1);
    final hasSharedPrefs = element.fields.any((field) => sharedChecker.hasAnnotationOfExact(field));

    output += "class $className with ChangeNotifier implements _$className {" +
        element.fields.map((field) => "${field.type.getDisplayString()} _${field.name};").join() +
        "$className({" +
        element.fields.map((field) => "${field.type.getDisplayString()} ${field.name}").join(',') +
        "}) :" +
        element.fields.map((field) => "this._${field.name} = ${field.name}").join(',') +
        ";";

    if (hasSharedPrefs)
      output += "factory $className.fromSharedPrefs(SharedPreferences prefs) => $className(" +
          (await Future.wait(
            element.fields.map(
              (field) async {
                if (!sharedChecker.hasAnnotationOfExact(field)) return '';

                final name = field.name;
                final type = field.type.getDisplayString();
                final entities = await getEntities(field);

                String sOutput = "$name: ";

                if (entities.length == 3) {
                  sOutput += "prefs.containsKey('$name') ? ";
                }

                if (sharedTypes.keys.contains(type)) {
                  sOutput += "prefs.get${sharedTypes[type]}('$name')";
                } else if (isEnum(field)) {
                  sOutput += "$type.values[prefs.getInt('$name')]";
                } else {
                  sOutput += "null /*UNKNOWN TYPE: $type*/";
                }

                if (entities.length == 3) {
                  sOutput += " : ${entities.last}";
                }

                return sOutput;
              },
            ),
          ))
              .join(',') +
          ");";

    element.fields.forEach((field) {
      final name = field.name;
      final type = field.type.getDisplayString();
      final isList = field.type.isDartCoreList;

      output += "$type get $name => ${isList ? 'UnmodifiableListView(this._$name);' : 'this._$name;'}"
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
