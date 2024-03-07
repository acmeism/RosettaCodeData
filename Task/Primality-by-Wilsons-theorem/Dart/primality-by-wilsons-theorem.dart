BigInt factorial(BigInt n) {
  if (n == BigInt.zero) {
    return BigInt.one;
  }

  BigInt result = BigInt.one;
  for (BigInt i = n; i > BigInt.zero; i = i - BigInt.one) {
    result *= i;
  }

  return result;
}

bool isWilsonPrime(BigInt n) {
  if (n < BigInt.from(2)) {
    return false;
  }

  return (factorial(n - BigInt.one) + BigInt.one) % n == BigInt.zero;
}

void main() {
  var wilsonPrimes = [];
  for (var i = BigInt.one; i <= BigInt.from(100); i += BigInt.one) {
    if (isWilsonPrime(i)) {
      wilsonPrimes.add(i);
    }
  }

  print(wilsonPrimes);
}
