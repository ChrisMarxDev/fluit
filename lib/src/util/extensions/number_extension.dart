extension IntExtension on int {
  String toThousandsString({String separator = '.'}) {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}$separator',
    );
  }
}

extension DoubleExtension on double {
  String toThousandsString({String separator = '.'}) {
    return toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}$separator',
    );
  }

  String toPercentageString() {
    return '${(this * 100).toStringAsFixed(0)}%';
  }

  double mapToSpace(
      NumberSpace<double> currentSpace, NumberSpace<double> targetSpace,) {
    return (this - currentSpace.min) * targetSpace.range / currentSpace.range +
        targetSpace.min;
  }

  double mapToSpaceMinMax(
      double minFrom, double maxFrom, double minTo, double maxTo,) {
    return (minFrom - minTo) * (maxTo - minTo) / (maxFrom - minFrom) + minTo;
  }
}

class NumberSpace<T extends num> {
  NumberSpace(this.min, this.max);

  final T min;
  final T max;

  num get range => max - min;

  num mapFromOtherSpace(num value, NumberSpace<T> otherSpace) {
    return (value - min) * otherSpace.range / range + otherSpace.min;
  }
}

extension NullSafeNumberExtension on num? {
  num? add(num? other) {
    if (this == null) return null;
    if (other == null) return this;
    return this! + other;
  }

  num? subtract(num? other) {
    if (this == null) return null;
    if (other == null) return this;
    return this! - other;
  }
}
