import 'package:analyzer/dart/element/element.dart';

Future<List<String>> getEntities(FieldElement field) async {
  return (await field.library.session.getResolvedLibraryByElement(field.library))
      .getElementDeclaration(field)
      .node
      .childEntities
      .map((entity) => entity.toString())
      .toList(growable: false);
}

bool isEnum(FieldElement field) => field.type.element.runtimeType.toString() == 'EnumElementImpl';
