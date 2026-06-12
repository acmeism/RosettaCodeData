import 'dart:math';

int leastSquare(int gap) {
  for (int n = 1;; n++) {
    if (pow(n, 2) - pow((n - 1), 2) > gap) {
      return n;
    }
  }
}

void main() {
  print(leastSquare(1000));
}
