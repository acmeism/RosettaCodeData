// Motzkin Numbers Calculator

class MotzkinNumbers {
  static main() {
    const count = 42;
    const motzkins = this.motzkinNumbers(count);

    console.log(" n        Motzkin[n]");
    console.log("-----------------------------");

    for (let n = 0; n < count; n++) {
      const motzkin = motzkins[n];
      const prime = this.isProbablePrime(motzkin);
      const formatted = motzkin.toLocaleString('en-GB');
      const line = `${n.toString().padStart(2)} ${formatted.padStart(23)}`;
      console.log(line + (prime ? " prime" : ""));
    }
  }

  static motzkinNumbers(size) {
    const result = [];
    result.push(1n);
    result.push(1n);

    for (let i = 2; i < size; i++) {
      const nextMotzkin = result[i - 1] * BigInt(2 * i + 1)
        + result[i - 2] * BigInt(3 * i - 3);
      result.push(nextMotzkin / BigInt(i + 2));
    }

    return result;
  }

  static isProbablePrime(n) {
    if (n < 2n) return false;
    if (n === 2n || n === 3n) return true;
    if (n % 2n === 0n) return false;

    // Miller-Rabin primality test (simplified)
    const witnesses = [2n, 3n, 5n, 7n, 11n, 13n, 17n, 19n, 23n, 29n];

    for (const witness of witnesses) {
      if (witness >= n) continue;
      if (!this.millerRabinTest(n, witness)) return false;
    }

    return true;
  }

  static millerRabinTest(n, a) {
    let d = n - 1n;
    let r = 0;

    while (d % 2n === 0n) {
      d /= 2n;
      r++;
    }

    let x = this.modPow(a, d, n);

    if (x === 1n || x === n - 1n) return true;

    for (let i = 0; i < r - 1; i++) {
      x = (x * x) % n;
      if (x === n - 1n) return true;
    }

    return false;
  }

  static modPow(base, exp, mod) {
    let result = 1n;
    base = base % mod;

    while (exp > 0n) {
      if (exp % 2n === 1n) {
        result = (result * base) % mod;
      }
      exp = exp / 2n;
      base = (base * base) % mod;
    }

    return result;
  }
}

// Run the program
MotzkinNumbers.main();
