// Rational class for rational number representation
class Rational {
  constructor(numerator, denominator) {
    if (denominator < 0) {
      this.numerator = -numerator;
      this.denominator = -denominator;
    } else {
      this.numerator = numerator;
      this.denominator = denominator;
    }

    if (numerator === 0) {
      this.denominator = 1;
    }

    const divisor = this.gcd(Math.abs(this.numerator), this.denominator);
    this.numerator = Math.floor(this.numerator / divisor);
    this.denominator = Math.floor(this.denominator / divisor);
  }

  gcd(a, b) {
    while (b !== 0) {
      const temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  toString() {
    return `${this.numerator} / ${this.denominator}`;
  }
}

// P_adic class for p-adic number representation
class P_adic {
  static PRECISION = 40;
  static ORDER_MAX = 1000;
  static DIGITS_SIZE = P_adic.PRECISION + 5;

  // Create a P_adic number with p = 'prime', from the given rational 'numerator' / 'denominator'
  constructor(prime, numerator, denominator, digits = null, order = null) {
    this.prime = prime;

    // If digits and order are provided, use them directly (for internal use)
    if (digits !== null && order !== null) {
      this.digits = digits;
      this.order = order;
      return;
    }

    if (denominator === 0) {
      throw new Error("Denominator cannot be zero");
    }

    this.order = 0;

    // Process rational zero
    if (numerator === 0) {
      this.digits = Array(P_adic.DIGITS_SIZE).fill(0);
      this.order = P_adic.ORDER_MAX;
      return;
    }

    // Remove multiples of 'prime' and adjust the order of the P_adic number accordingly
    while (this.moduloPrime(numerator) === 0) {
      numerator = Math.floor(numerator / prime);
      this.order += 1;
    }

    while (this.moduloPrime(denominator) === 0) {
      denominator = Math.floor(denominator / prime);
      this.order -= 1;
    }

    // Standard calculation of P_adic digits
    const inverse = this.moduloInverse(denominator);
    this.digits = [];

    while (this.digits.length < P_adic.DIGITS_SIZE) {
      const digit = this.moduloPrime(numerator * inverse);
      this.digits.push(digit);

      numerator -= digit * denominator;

      if (numerator !== 0) {
        // The denominator is not a power of a prime
        let count = 0;
        while (this.moduloPrime(numerator) === 0) {
          numerator = Math.floor(numerator / prime);
          count += 1;
        }

        for (let i = count; i > 1; --i) {
          this.digits.push(0);
        }
      }
    }
  }

  // Return the sum of this P_adic number with the given P_adic number
  add(other) {
    if (this.prime !== other.prime) {
      throw new Error("Cannot add p-adic's with different primes");
    }

    let this_digits = [...this.digits];
    let other_digits = [...other.digits];
    let result = [];

    // Adjust the digits so that the P_adic points are aligned
    for (let i = 0; i < -this.order + other.order; ++i) {
      other_digits.unshift(0);
    }

    for (let i = 0; i < -other.order + this.order; ++i) {
      this_digits.unshift(0);
    }

    // Standard digit by digit addition
    let carry = 0;
    for (let i = 0; i < Math.min(this_digits.length, other_digits.length); ++i) {
      const sum = this_digits[i] + other_digits[i] + carry;
      const remainder = sum % this.prime;
      carry = (sum >= this.prime) ? 1 : 0;
      result.push(remainder);
    }

    return new P_adic(
      this.prime,
      null,
      null,
      result,
      this.allZeroDigits(result) ? P_adic.ORDER_MAX : Math.min(this.order, other.order)
    );
  }

  // Return the Rational representation of this P_adic number
  convertToRational() {
    let numbers = [...this.digits];

    // Zero
    if (numbers.length === 0 || this.allZeroDigits(numbers)) {
      return new Rational(0, 1);
    }

    // Positive integer
    if (this.order >= 0 && this.endsWith(numbers, 0)) {
      for (let i = 0; i < this.order; ++i) {
        numbers.unshift(0);
      }

      return new Rational(this.convertToDecimal(numbers), 1);
    }

    // Negative integer
    if (this.order >= 0 && this.endsWith(numbers, this.prime - 1)) {
      this.negateDigits(numbers);
      for (let i = 0; i < this.order; ++i) {
        numbers.unshift(0);
      }

      return new Rational(-this.convertToDecimal(numbers), 1);
    }

    // Rational
    const copy = new P_adic(this.prime, null, null, [...this.digits], this.order);
    let sum = new P_adic(this.prime, null, null, [...this.digits], this.order);
    let denominator = 1;

    do {
      sum = sum.add(copy);
      denominator += 1;
    } while (!(this.endsWith(sum.digits, 0) || this.endsWith(sum.digits, this.prime - 1)));

    const negative = this.endsWith(sum.digits, this.prime - 1);
    if (negative) {
      this.negateDigits(sum.digits);
    }

    let numerator = negative ? -this.convertToDecimal(sum.digits) : this.convertToDecimal(sum.digits);

    if (this.order > 0) {
      numerator *= Math.pow(this.prime, this.order);
    }

    if (this.order < 0) {
      denominator *= Math.pow(this.prime, -this.order);
    }

    return new Rational(numerator, denominator);
  }

  // Return a string representation of this P_adic number
  toString() {
    let numbers = [...this.digits];
    this.padWithZeros(numbers);

    let result = "";
    for (let i = numbers.length - 1; i >= 0; --i) {
      result += this.digits[i].toString();
    }

    if (this.order >= 0) {
      for (let i = 0; i < this.order; ++i) {
        result += "0";
      }

      result += ".0";
    } else {
      result = result.slice(0, result.length + this.order) + "." + result.slice(result.length + this.order);

      while (result[result.length - 1] === '0') {
        result = result.substring(0, result.length - 1);
      }
    }

    return " ..." + result.substring(result.length - P_adic.PRECISION - 1);
  }

  // Transform the given array of digits representing a P_adic number
  // into an array which represents the negation of the P_adic number
  negateDigits(numbers) {
    numbers[0] = this.moduloPrime(this.prime - numbers[0]);
    for (let i = 1; i < numbers.length; ++i) {
      numbers[i] = this.prime - 1 - numbers[i];
    }
  }

  // Return the multiplicative inverse of the given number modulo 'prime'
  moduloInverse(number) {
    let inverse = 1;
    while (this.moduloPrime(inverse * number) !== 1) {
      inverse += 1;
    }
    return inverse;
  }

  // Return the given number modulo 'prime' in the range 0...'prime' - 1
  moduloPrime(number) {
    const div = number % this.prime;
    return (div >= 0) ? div : div + this.prime;
  }

  // The given array is padded on the right by zeros up to a maximum length of 'DIGITS_SIZE'
  padWithZeros(array) {
    while (array.length < P_adic.DIGITS_SIZE) {
      array.push(0);
    }
  }

  // Return the given array of base 'prime' integers converted to a decimal integer
  convertToDecimal(numbers) {
    let decimal = 0;
    let multiple = 1;
    for (const number of numbers) {
      decimal += number * multiple;
      multiple *= this.prime;
    }
    return decimal;
  }

  // Return whether the given array consists of all zeros
  allZeroDigits(numbers) {
    for (const number of numbers) {
      if (number !== 0) {
        return false;
      }
    }
    return true;
  }

  // Return whether the given array ends with multiple instances of the given number
  endsWith(numbers, number) {
    for (let i = numbers.length - 1; i >= numbers.length - P_adic.PRECISION / 2; --i) {
      if (numbers[i] !== number) {
        return false;
      }
    }
    return true;
  }
}

// Main function equivalent
function main() {
  console.log("3-adic numbers:");
  let padic_one = new P_adic(3, -2, 87);
  console.log("-2 / 87    => " + padic_one.toString());
  let padic_two = new P_adic(3, 4, 97);
  console.log("4 / 97     => " + padic_two.toString());

  let sum = padic_one.add(padic_two);
  console.log("sum        => " + sum.toString());
  console.log("Rational = " + sum.convertToRational().toString());
  console.log();

  console.log("7-adic numbers:");
  padic_one = new P_adic(7, 5, 8);
  console.log("5 / 8       => " + padic_one.toString());
  padic_two = new P_adic(7, 353, 30809);
  console.log("353 / 30809 => " + padic_two.toString());

  sum = padic_one.add(padic_two);
  console.log("sum         => " + sum.toString());
  console.log("Rational = " + sum.convertToRational().toString());
  console.log();
}

// Run the main function
main();
