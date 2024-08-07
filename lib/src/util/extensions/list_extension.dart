import 'dart:collection';
import 'dart:math';

extension ListExtension<T> on List<T> {
  T random() {
    if (isEmpty) {
      throw Exception('List is empty');
    }
    return this[Random().nextInt(length)];
  }

  List<T> separatedBy(T separator) {
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) {
        result.add(separator);
      }
    }
    return result;
  }

  List<T> removed(T element) {
    return where((e) => e != element).toList();
  }

  List<T> removedWhere(bool Function(T) predicate) {
    return where((e) => !predicate(e)).toList();
  }

  List<T> replaced(T newElement, bool Function(T) predicate) {
    return map((e) => predicate(e) ? newElement : e).toList();
  }

  List<T> replacedOrAdded(T newElement, bool Function(T) predicate) {
    final index = indexWhere(predicate);
    if (index == -1) {
      return [...this, newElement];
    } else {
      return this.replaced(newElement, predicate);
    }
  }

  List<T> reordered(int oldIndex, int newIndex) {
    final element = this[oldIndex];
    final newList = List<T>.from(this);
    newList.removeAt(oldIndex);
    newList.insert(newIndex.clamp(0, newList.length), element);
    return newList;
  }
}

extension MapEntryListExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() {
    return Map.fromEntries(this);
  }
}

extension IterableExtension<Item> on Iterable<Item> {
  Map<Key, Item> toMapAsValues<Key>(Key Function(Item) key) {
    return HashMap.fromEntries(
      map(
        (e) => MapEntry(key(e), e),
      ),
    );
  }

  Map<Item, Value> toMapAsKeys<Value>(Value Function(Item) value) {
    return HashMap.fromEntries(
      map(
        (e) => MapEntry(e, value(e)),
      ),
    );
  }

  Iterable<Item> operator +(Iterable<Item> other) {
    return followedBy(other);
  }
}
