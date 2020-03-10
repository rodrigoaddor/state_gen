import 'package:state_gen/annotations.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

Future<List<String>> getEntities(FieldElement field) async {
  return (await field.library.session.getResolvedLibraryByElement(field.library))
      .getElementDeclaration(field)
      .node
      .childEntities
      .map((entity) => entity.toString())
      .toList(growable: false);
}

extension FieldUtils on FieldElement {
  bool get isEnum => this.type.element.runtimeType.toString() == 'EnumElementImpl';
  bool get isShared => TypeChecker.fromRuntime(shared.runtimeType).hasAnnotationOfExact(this);
}
