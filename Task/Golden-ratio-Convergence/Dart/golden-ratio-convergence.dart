import 'dart:math';

void iterate() {
  int count = 0;
  double phi0 = 1.0;
  double phi1;
  double difference;
  do {
    phi1 = 1.0 + (1.0 / phi0);
    difference = (phi1 - phi0).abs();
    phi0 = phi1;
    count += 1;
  } while (1.0e-5 < difference);

  print("Result: $phi1 after $count iterations");
  print("The error is approximately ${phi1 - (0.5 * (1.0 + sqrt(5.0)))}");
}

void main() {
  iterate();
}
