import 'package:more/more.dart';

void main(List<String> args) {
  print(0.to(1000).where(isPrime));
  print(isPrime(1849551425));
  print(isPrime(1849551427));
}

bool isPrime(int n) {
  var k = 10;
  if (n < 2) return false;
  if (n == 2) return true;
  if (n.isEven) return false;
  var d = n - 1;
  var s = 0;
  while (d.isEven) {
    d ~/= 2;
    s += 1;
  }
  LOOP:
  for (var _ in 0.to(k)) {
    var a = 2.to(n - 2).atRandom();
    var x = a.modPow(d, n);
    if (x == 1 || x == n - 1) continue LOOP;
    for (var _ in 0.to(s - 1)) {
      x = x.modPow(2, n);
      if (x == 1) return false;
      if (x == n - 1) continue LOOP;
    }
    return false;
  }
  return true;
}
