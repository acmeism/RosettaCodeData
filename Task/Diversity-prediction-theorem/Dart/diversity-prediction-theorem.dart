double sum(List<double> array) {
  double s = 0;
  for (var x in array) s += x;
  return s;
}

double square(double x) => x * x;

double mean(List<double> array) => sum(array) / array.length;

double averageSquareDiff(double a, List<double> predictions) {
  List<double> results = [];
  for (var x in predictions) {
    results.add(square(x - a));
  }
  return mean(results);
}

void diversityTheorem(double truth, List<double> predictions) {
  double avgErr = averageSquareDiff(truth, predictions);
  double avg = mean(predictions);
  double crowdErr = square(truth - avg);
  double diversity = averageSquareDiff(avg, predictions);

  print("Average error: ${avgErr.toStringAsFixed(4)}");
  print("  Crowd error: ${crowdErr.toStringAsFixed(4)}");
  print("    Diversity: ${diversity.toStringAsFixed(4)}\n");
}

void main() {
  diversityTheorem(49, [48, 47, 51]);
  diversityTheorem(49, [48, 47, 51, 42]);
}
