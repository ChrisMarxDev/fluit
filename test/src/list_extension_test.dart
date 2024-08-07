// import 'dart:collection';
// import 'dart:math';
//
// extension ListExtension<T> on List<T> {
//   T random() {
//     if (isEmpty) {
//       throw Exception('List is empty');
//     }
//     return this[Random().nextInt(length)];
//   }
//
//   List<T> separatedBy(T separator) {
//     final result = <T>[];
//     for (var i = 0; i < length; i++) {
//       result.add(this[i]);
//       if (i != length - 1) {
//         result.add(separator);
//       }
//     }
//     return result;
//   }
//
//   List<T> removed(T element) {
//     return where((e) => e != element).toList();
//   }
//
//   List<T> replaced(T newElement, bool Function(T) predicate) {
//     return map((e) => predicate(e) ? newElement : e).toList();
//   }
//
//   List<T> replacedOrAdded(T newElement, bool Function(T) predicate) {
//     final index = indexWhere(predicate);
//     if (index == -1) {
//       return [...this, newElement];
//     } else {
//       return [...this.replaced(newElement, predicate), newElement];
//     }
//   }
// }

import 'package:fluit/src/util/extensions/list_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListExtension', () {
    test('SeparatedBy works', () {
      final list = [1, 2, 3, 4, 5];
      final separated = list.separatedBy(0);
      expect(separated, [1, 0, 2, 0, 3, 0, 4, 0, 5]);
    });
    test('Removed works', () {
      final list = [1, 2, 3, 4, 5];
      final removed = list.removed(2);
      expect(removed, [1, 3, 4, 5]);
      expect(list, [1, 2, 3, 4, 5]);
    });
    test('Replaced works', () {
      final list = [1, 2, 3, 4, 5];
      final replaced = list.replaced(0, (e) => e == 2);
      expect(replaced, [1, 0, 3, 4, 5]);
      expect(list, [1, 2, 3, 4, 5]);
    });
    test('ReplacedOrAdded works', () {
      final list = [1, 2, 3, 4, 5];
      final notReplaced = list.replacedOrAdded(0, (e) => e == 8);
      final replacedOrAdded = list.replacedOrAdded(0, (e) => e == 2);
      expect(notReplaced, [1, 2, 3, 4, 5, 0]);
      expect(replacedOrAdded, [
        1,
        0,
        3,
        4,
        5,
      ]);
      expect(list, [1, 2, 3, 4, 5]);
    });

    test('Reorder works', () {
      final list = [1, 2, 3, 4, 5];
      final reordered = list.reordered(1, 0);
      expect(reordered, [2, 1, 3, 4, 5]);
      expect(list, [1, 2, 3, 4, 5]);
    });
  });
}
