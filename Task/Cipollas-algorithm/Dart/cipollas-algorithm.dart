import 'dart:math';

final Random random = Random();

// Return a random number within the range min..max, both inclusive
int rangeRandom(int min, int max) {
  return min + random.nextInt(max - min + 1);
}

// Return a * b mod modulus
int multiplyModulus(int a, int b, int modulus) {
  int result = 0;
  int aa = a % modulus;
  while (b > 0) {
    if ((b & 1) == 1) {
      result = (result + aa) % modulus;
    }
    aa = (aa << 1) % modulus;
    b >>= 1;
  }
  return result;
}

// Return b^power mod modulus
int powerModulus(int base, int power, int modulus) {
  int result = 1;
  while (power > 0) {
    if ((power & 1) == 1) {
      result = multiplyModulus(result, base, modulus);
    }
    base = multiplyModulus(base, base, modulus);
    power >>= 1;
  }
  return result;
}

// Helper function for the 'isPrime' function
bool isWitness(int a, int n) {
  int t = 0;
  int u = n - 1;
  while ((u & 1) == 0) {
    t = t + 1;
    u >>= 1;
  }
  int xx = powerModulus(a, u, n);
  for (int i = 0; i < t; ++i) {
    int yy = multiplyModulus(xx, xx, n);
    if (yy == 1 && xx != 1 && xx != n - 1) {
      return true;
    }
    xx = yy;
  }
  return (xx == 1) ? false : true;
}

// Uses the Miller-Rabin algorithm
bool isPrime(int n) {
  if (n <= 1) {
    return false;
  }
  const List<int> primes = [2, 3, 5, 7, 11, 13, 17];
  if (primes.contains(n)) {
    return true;
  }
  for (int prime in primes) {
    if (isWitness(prime, n)) {
      return false;
    }
  }
  return true;
}

int legendreSymbol(int a, int p) {
  final int x = powerModulus(a, (p - 1) ~/ 2, p);
  if (p - 1 == x) {
    return x - p;
  }
  return x;
}

class Fp2 {
  int x, y;
  Fp2(this.x, this.y);
}

Fp2 multiplyFp2(Fp2 a, Fp2 b, int prime, int w2) {
  Fp2 result = Fp2(0, 0);
  int temp1 = multiplyModulus(a.x, b.x, prime);
  int temp2 = multiplyModulus(a.y, b.y, prime);
  temp2 = multiplyModulus(temp2, w2, prime);
  result.x = (temp1 + temp2) % prime;
  temp1 = multiplyModulus(a.x, b.y, prime);
  temp2 = multiplyModulus(a.y, b.x, prime);
  result.y = (temp1 + temp2) % prime;
  return result;
}

Fp2 powerFp2(Fp2 a, int power, int prime, int w2) {
  Fp2 result = Fp2(0, 0);
  if (power == 0) {
    result.x = 1;
    result.y = 0;
    return result;
  }
  if (power == 1) {
    return a;
  }
  if ((power & 1) == 0) {
    Fp2 temp = powerFp2(a, power ~/ 2, prime, w2);
    return multiplyFp2(temp, temp, prime, w2);
  } else {
    return multiplyFp2(a, powerFp2(a, power - 1, prime, w2), prime, w2);
  }
}

void test(int n, int p) {
  print("Finding solutions for number = $n and prime = $p:");
  if (p == 2 || !isPrime(p)) {
    print("No solutions, since p is not an odd prime.\n");
    return;
  }
  // p is an odd prime
  if (legendreSymbol(n, p) != 1) {
    print("No solutions, since $n is not a square in F$p\n");
    return;
  }
  int a, w2;
  int x1, x2;
  Fp2 result = Fp2(0, 0);
  while (true) {
    do {
      a = rangeRandom(2, p);
      w2 = a * a - n;
    } while (legendreSymbol(w2, p) != -1);
    result.x = a;
    result.y = 1;
    result = powerFp2(result, (p + 1) ~/ 2, p, w2);
    if (result.y != 0) {
      continue;
    }
    x1 = result.x;
    x2 = p - x1;
    if (multiplyModulus(x1, x1, p) == n && multiplyModulus(x2, x2, p) == n) {
      print("Square roots of $n are ($x1 and $x2) mod $p\n");
      return;
    }
  }
}

void main() {
  test(10, 13);
  test(56, 101);
  test(8218, 10007);
  test(8219, 10007);
  test(331575, 1000003);
  test(665165880, 1000000007);
  // test(881398088036, 1000000000039);
  // test(12345678901234567, 1000000000000000031);
}

