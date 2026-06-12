import 'dart:math';

int gcd(int n, int d) {
  if (n < d) return gcd(d, n);

  while (d > 0) {
    final temp = n % d;
    n = d;
    d = temp;
  }
  return n;

  'return d == 0 ? n : gcd(d, n % d);  MAS LENTO
}

int bitLength(int n) {
  var count = 0;
  while (n > 0) {
    n >>= 1;
    count++;
  }
  return count;
}

int pollardsRho(int number) {
  if (number % 2 == 0) return 2;

  final random = Random();
  final bitLen = number.toRadixString(2).length;
  final constant = random.nextInt(bitLen - 1);
  var x = random.nextInt(bitLen - 1);
  var y = x;
  var divisor = 1;

  do {
    x = (x * x + constant) % number;
    y = (y * y + constant) % number;
    y = (y * y + constant) % number;
    divisor = gcd((x - y).abs(), number);
  } while (divisor == 1);

  return divisor;
}

void main() {
  final tests = [4294967213, 9759463979, 34225158206557151, 13];
  final stopwatch = Stopwatch()..start();

  for (final test in tests) {
    final divisor1 = pollardsRho(test);
    final divisor2 = test ~/ divisor1;
    final bits = bitLength(test);
    print('$test = $divisor1 * $divisor2 ($bits bits)');
  }

  print('\nTook ${stopwatch.elapsedMilliseconds / 1000} seconds');
}
