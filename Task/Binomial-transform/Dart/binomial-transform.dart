import 'dart:math' as math;

void printVector(List<int> vec) {
  print(vec.join(' '));
}

int factorial(int number) {
  if (number > 20) {
    throw ArgumentError('Too large for 64 bit number: $number');
  }
  if (number < 2) {
    return 1;
  }

  int result = 1;
  for (int i = 2; i <= number; i++) {
    result *= i;
  }
  return result;
}

int binomial(int n, int k) {
  return factorial(n) ~/ factorial(n - k) ~/ factorial(k);
}

List<int> forward(List<int> vec) {
  List<int> transform = List.filled(vec.length, 0);
  for (int n = 0; n < vec.length; n++) {
    for (int k = 0; k <= n; k++) {
      transform[n] += binomial(n, k) * vec[k];
    }
  }
  return transform;
}

List<int> inverse(List<int> vec) {
  List<int> transform = List.filled(vec.length, 0);
  for (int n = 0; n < vec.length; n++) {
    for (int k = 0; k <= n; k++) {
      int sign = ((n - k) & 1) != 0 ? -1 : 1;
      transform[n] += binomial(n, k) * vec[k] * sign;
    }
  }
  return transform;
}

List<int> selfInverting(List<int> vec) {
  List<int> transform = List.filled(vec.length, 0);
  for (int n = 0; n < vec.length; n++) {
    for (int k = 0; k <= n; k++) {
      int sign = (k & 1) != 0 ? -1 : 1;
      transform[n] += binomial(n, k) * vec[k] * sign;
    }
  }
  return transform;
}

void main() {
  final List<List<int>> sequences = [
    [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845],
    [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
    [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181],
    [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37]
  ];

  final List<String> names = [
    "Catalan number sequence:",
    "Prime flip-flop sequence:",
    "Fibonacci number sequence:",
    "Padovan number sequence:"
  ];

  for (int i = 0; i < sequences.length; i++) {
    print(names[i]);
    printVector(sequences[i]);
    print("Forward binomial transform:");
    printVector(forward(sequences[i]));
    print("Inverse binomial transform:");
    printVector(inverse(sequences[i]));
    print("Round trip:");
    printVector(inverse(forward(sequences[i])));
    print("Self-inverting:");
    printVector(selfInverting(sequences[i]));
    print("Round trip self-inverting:");
    printVector(selfInverting(selfInverting(sequences[i])));
    print("\n");
  }
}
