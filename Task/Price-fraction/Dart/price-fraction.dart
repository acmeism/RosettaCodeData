class Range {
  final double start;
  final double end;

  Range(this.start, this.end);

  bool contains(double value) {
    return value >= start && value < end;
  }
}

List<MapEntry<Range, double>> ranges = [
  MapEntry(Range(0.00, 0.06), 0.10),
  MapEntry(Range(0.06, 0.11), 0.18),
  MapEntry(Range(0.11, 0.16), 0.26),
  MapEntry(Range(0.16, 0.21), 0.32),
  MapEntry(Range(0.21, 0.26), 0.38),
  MapEntry(Range(0.26, 0.31), 0.44),
  MapEntry(Range(0.31, 0.36), 0.50),
  MapEntry(Range(0.36, 0.41), 0.54),
  MapEntry(Range(0.41, 0.46), 0.58),
  MapEntry(Range(0.46, 0.51), 0.62),
  MapEntry(Range(0.51, 0.56), 0.66),
  MapEntry(Range(0.56, 0.61), 0.70),
  MapEntry(Range(0.61, 0.66), 0.74),
  MapEntry(Range(0.66, 0.71), 0.78),
  MapEntry(Range(0.71, 0.76), 0.82),
  MapEntry(Range(0.76, 0.81), 0.86),
  MapEntry(Range(0.81, 0.86), 0.90),
  MapEntry(Range(0.86, 0.91), 0.94),
  MapEntry(Range(0.91, 0.96), 0.98),
  MapEntry(Range(0.96, 1.01), 1.00),
];

double adjustDouble(double val, List<MapEntry<Range, double>> ranges) {
  for (var range in ranges) {
    if (range.key.contains(val)) {
      return range.value;
    }
  }
  return val; // Return the original value if no range is found
}

void main() {
  for (double val = 0.0; val <= 1.0; val += 0.01) {
    String strFmt(double n) => n.toStringAsFixed(2);

    double adjusted = adjustDouble(val, ranges);
    print("${strFmt(val)} -> ${strFmt(adjusted)}");
  }
}
