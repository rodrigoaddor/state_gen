import 'package:analyzer/dart/element/element.dart';

Future<List<String>> getEntities(FieldElement field) async {
  final library = await field.library.session.getResolvedLibraryByElement(field.library);
  final declaration = library.getElementDeclaration(field);
  final values = (declaration.node.childEntities);
  return values.map((entity) => entity.toString()).toList(growable: false);
}

bool isEnum(FieldElement field) => field.type.element.runtimeType.toString() == 'EnumElementImpl';
