class Rational {
  constructor(numerator, denominator) {
    if (denominator === 0n) throw new Error("Denominator cannot be zero");
    if (numerator === 0n) denominator = 1n;
    if (denominator < 0n) {
      this.numer = -numerator;
      this.denom = -denominator;
    } else {
      this.numer = numerator;
      this.denom = denominator;
    }
    const g = this.#gcd(this.numer < 0n ? -this.numer : this.numer, this.denom);
    this.numer /= g;
    this.denom /= g;
  }

  add(other) {
    return new Rational(this.numer * other.denom + other.numer * this.denom, this.denom * other.denom);
  }

  subtract(other) {
    return new Rational(this.numer * other.denom - other.numer * this.denom, this.denom * other.denom);
  }

  multiply(other) {
    return new Rational(this.numer * other.numer, this.denom * other.denom);
  }

  divide(other) {
    return new Rational(this.numer * other.denom, this.denom * other.numer);
  }

  floor() {
    return new Rational(this.numer / this.denom, 1n);
  }

  numerator() { return this.numer; }
  denominator() { return this.denom; }

  toString() { return `${this.numer}/${this.denom}`; }

  #gcd(a, b) { return b === 0n ? a : this.#gcd(b, a % b); }

  static ONE = new Rational(1n, 1n);
  static TWO = new Rational(2n, 1n); // Fixed: was 2n, 2n
}

function nextCalkinWilf(term) {
  const divisor = Rational.TWO.multiply(term.floor()).add(Rational.ONE).subtract(term);
  return Rational.ONE.divide(divisor);
}

function continuedFraction(rational) {
  let numerator = rational.numerator();
  let denominator = rational.denominator();
  const result = [];

  while (numerator !== 1n) {
    result.push(numerator / denominator);
    const copyNumerator = numerator;
    numerator = denominator;
    denominator = copyNumerator % denominator;
  }

  if (result.length > 0 && result.length % 2 === 0) {
    const back = result.pop();
    result.push(back - 1n);
    result.push(1n);
  }

  return result;
}

function termIndex(rational) {
  let result = 0n;
  let binaryDigit = 1n;
  let power = 0n;

  for (const term of continuedFraction(rational)) {
    for (let i = 0n; i < term; i++, power++) {
      result |= (binaryDigit << power);
    }
    binaryDigit = binaryDigit === 0n ? 1n : 0n;
  }

  return result;
}

// Main
let term = Rational.ONE;
console.log("First 20 terms of the Calkin-Wilf sequence are:");
for (let i = 1; i <= 20; i++) {
  console.log(`${String(i).padStart(2)}: ${term}`);
  term = nextCalkinWilf(term);
}

console.log();
const rational = new Rational(83116n, 51639n);
console.log(` ${rational} is the ${termIndex(rational)}th term of the sequence.`);
