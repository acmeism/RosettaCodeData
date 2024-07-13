double i = 0;
double sum(int lo, int hi, double Function() term) {
  double temp = 0;
  for (i = lo.toDouble(); i <= hi; i++) temp += term();
  return temp;
}

double termFunc() {
  return 1.0 / i;
}

void main() {
  print(sum(1, 100, termFunc));
}
