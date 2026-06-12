import 'dart:math';

void main() {
  List<int> res = [1];
  int count = 1;
  int i = 2;
  int lim1 = 100;
  int lim2 = 1000;
  double max = 1e7;
  var t0 = DateTime.now();

  while (count < max) {
    bool cubeFree = false;
    List<int> factors = primeFactors(i);
    if (factors.length < 3) {
      cubeFree = true;
    } else {
      cubeFree = true;
      for (int i = 2; i < factors.length; i++) {
        if (factors[i - 2] == factors[i - 1] && factors[i - 1] == factors[i]) {
          cubeFree = false;
          break;
        }
      }
    }
    if (cubeFree) {
      if (count < lim1) res.add(factors.last);
      count += 1;
      if (count == lim1) {
        print("First $lim1 terms of a[n]:");
        print(res.take(lim1).join(', '));
        print("");
      } else if (count == lim2) {
        print("The $count term of a[n] is ${factors.last}");
        lim2 *= 10;
      }
    }
    i += 1;
  }
  print("${DateTime.now().difference(t0).inSeconds} sec.");
}

List<int> primeFactors(int n) {
  List<int> factors = [];
  while (n % 2 == 0) {
    factors.add(2);
    n ~/= 2;
  }
  for (int i = 3; i <= sqrt(n); i += 2) {
    while (n % i == 0) {
      factors.add(i);
      n ~/= i;
    }
  }
  if (n > 2) {
    factors.add(n);
  }
  return factors;
}
