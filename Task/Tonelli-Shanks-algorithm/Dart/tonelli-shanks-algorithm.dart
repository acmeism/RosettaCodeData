class Pair {
  final int n;
  final int p;

  Pair(this.n, this.p);
}

class Solution {
  final int root1;
  final int root2;
  final bool isSquare;

  Solution(this.root1, this.root2, this.isSquare);
}

int multiplyModulus(int a, int b, int modulus) {
  a %= modulus;
  b %= modulus;
  if (b < a) {
    var temp = a;
    a = b;
    b = temp;
  }

  int result = 0;
  while (a > 0) {
    if (a % 2 == 1) {
      result = (result + b) % modulus;
    }
    b = (b << 1) % modulus;
    a >>= 1;
  }
  return result;
}

int powerModulus(int base, int exponent, int modulus) {
  if (modulus == 1) return 0;

  base %= modulus;
  int result = 1;
  while (exponent > 0) {
    if ((exponent & 1) == 1) {
      result = multiplyModulus(result, base, modulus);
    }
    base = multiplyModulus(base, base, modulus);
    exponent >>= 1;
  }
  return result;
}

int legendre(int a, int p) {
  return powerModulus(a, (p - 1) ~/ 2, p);
}

Solution tonelliShanks(int n, int p) {
  if (legendre(n, p) != 1) {
    return Solution(0, 0, false);
  }

  // Factor out powers of 2 from p - 1
  int q = p - 1;
  int s = 0;
  while (q % 2 == 0) {
    q ~/= 2;
    s += 1;
  }

  if (s == 1) {
    int result = powerModulus(n, (p + 1) ~/ 4, p);
    return Solution(result, p - result, true);
  }

  // Find a non-square z such that (z | p) = -1
  int z = 2;
  while (legendre(z, p) != p - 1) {
    z += 1;
  }

  int c = powerModulus(z, q, p);
  int t = powerModulus(n, q, p);
  int m = s;
  int result = powerModulus(n, (q + 1) ~/ 2, p);

  while (t != 1) {
    int i = 1;
    int zTemp = multiplyModulus(t, t, p);
    while (zTemp != 1 && i < m - 1) {
      i += 1;
      zTemp = multiplyModulus(zTemp, zTemp, p);
    }

    int b = powerModulus(c, 1 << (m - i - 1), p);
    c = multiplyModulus(b, b, p);
    t = multiplyModulus(t, c, p);
    m = i;
    result = multiplyModulus(result, b, p);
  }

  return Solution(result, p - result, true);
}

void main() {
  final List<Pair> tests = [
    Pair(10, 13),
    Pair(56, 101),
    Pair(1030, 1009),
    Pair(1032, 1009),
    Pair(44402, 100049),
    Pair(665820697, 1000000009),
    Pair(881398088036, 1000000000039),
  ];

  for (final test in tests) {
    final solution = tonelliShanks(test.n, test.p);
    print('n = ${test.n}, p = ${test.p}');
    if (solution.isSquare) {
      print('has solutions: ${solution.root1} and ${solution.root2}\n');
    } else {
      print('has no solutions because n is not a square modulo p\n');
    }
  }
}
