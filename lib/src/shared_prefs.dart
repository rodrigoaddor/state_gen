import 'package:analyzer/dart/element/element.dart';

import 'package:state_gen/src/utils.dart';

const sharedTypes = const {
  'bool': 'Bool',
  'double': 'Double',
  'int': 'Int',
  'List<String>': 'StringList',
  'String': 'String',
};

Future<String> generateSharedPrefsFactory(ClassElement element) async {
  final className = element.name.substring(1);
  final fields = element.fields.where((field) => field.isShared);

  final factoryFields = (await Future.wait(fields.map((field) async {
    final name = field.name;
    final type = field.type.getDisplayString();
    final entities = await getEntities(field);
    final defaultVal = entities.length >= 3 ? entities.last : "null";

    if (sharedTypes.containsKey(type)) {
      final sharedType = sharedTypes[type];
      return "$name: prefs.containsKey('$name') ? prefs.get$sharedType('$name') : $defaultVal,";
    } else if (field.isEnum) {
      return "$name: prefs.containsKey('$name') ? $type.values[prefs.getInt('$name')] : $defaultVal,";
    } else {
      return "$name: null /*UNKNOWN TYPE: $type*/,";
    }
  })))
      .join('\n');

  return """
    factory $className.fromSharedPrefs(SharedPreferences prefs) => $className(
      $factoryFields
    );
  """;
}

String generateSharedPrefsSetter(FieldElement field) {
  final name = field.name;
  final type = field.type.getDisplayString();

  if (sharedTypes.keys.contains(type)) {
    return "SharedPreferences.getInstance().then((prefs) => prefs.set${sharedTypes[type]}('$name', value));";
  } else if (field.isEnum) {
    return "SharedPreferences.getInstance().then((prefs) => prefs.setInt('$name', value.index));";
  } else {
    return "/*UNKNOWN TYPE: $type*/";
  }
}
