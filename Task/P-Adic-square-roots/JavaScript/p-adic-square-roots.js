// PAdicSquareRoot represents a p-adic square root number
class PAdicSquareRoot {
  constructor(prime, precision, digits = [], order = 0) {
    this.prime = prime;
    this.precision = precision;
    this.digits = digits;
    this.order = order;
  }

  // Clone returns a copy of the PAdicSquareRoot
  clone() {
    return new PAdicSquareRoot(
      this.prime,
      this.precision,
      [...this.digits],
      this.order
    );
  }

  // Negate returns the additive inverse of this p-adic square root number
  negate() {
    if (this.digits.length === 0) {
      return this.clone();
    }

    const result = this.clone();
    negateDigits(result.digits, this.prime);
    return result;
  }

  // Multiply returns the product of this p-adic square root number and another
  multiply(other) {
    if (this.prime !== other.prime) {
      throw new Error("Cannot multiply p-adic's with different primes");
    }

    if (this.digits.length === 0 || other.digits.length === 0) {
      return createPAdicSquareRoot(this.prime, this.precision, 0, 1);
    }

    const digitsSize = this.precision + 5;
    const product = multiplyDigits(this.digits, other.digits, this.prime, digitsSize);

    return new PAdicSquareRoot(
      this.prime,
      this.precision,
      product,
      this.order + other.order
    );
  }

  // ConvertToRational returns a string representation of this p-adic square root as a rational number
  convertToRational() {
    if (this.digits.length === 0) {
      return "0 / 1";
    }

    // Lagrange lattice basis reduction in two dimensions
    let seriesSum = this.digits[0];
    let maximumPrime = 1n;

    for (let i = 1; i < this.precision; i++) {
      maximumPrime *= BigInt(this.prime);
      seriesSum += this.digits[i] * Number(maximumPrime);
    }

    const one = [Number(maximumPrime), seriesSum];
    const two = [0, 1];

    let previousNorm = seriesSum * seriesSum + 1;
    let currentNorm = previousNorm + 1;
    let i = 0;
    let j = 1;

    while (previousNorm < currentNorm) {
      const numerator = one[i] * one[j] + two[i] * two[j];
      const denominator = previousNorm;
      currentNorm = Math.floor(numerator / denominator + 0.5);
      one[i] -= currentNorm * one[j];
      two[i] -= currentNorm * two[j];

      currentNorm = previousNorm;
      previousNorm = one[i] * one[i] + two[i] * two[i];

      if (previousNorm < currentNorm) {
        [one[i], one[j]] = [one[j], one[i]];
        [two[i], two[j]] = [two[j], two[i]];
      }
    }

    let x = one[j];
    let y = two[j];
    if (y < 0) {
      y = -y;
      x = -x;
    }

    if (Math.abs(one[i] * y - x * two[i]) !== Number(maximumPrime)) {
      throw new Error("Rational reconstruction failed");
    }

    for (let k = this.order; k < 0; k++) {
      y *= this.prime;
    }

    for (let k = 0; k < this.order; k++) {
      x *= this.prime;
    }

    return `${x} / ${y}`;
  }

  // String returns a string representation of this p-adic square root
  toString() {
    const digits = [...this.digits];

    // Pad with zeros if needed
    while (digits.length < this.precision + 5) {
      digits.push(0);
    }

    let result = "";
    for (let i = digits.length - 1; i >= 0; i--) {
      result += digits[i].toString();
    }

    let resultStr = result;

    if (this.order >= 0) {
      for (let i = 0; i < this.order; i++) {
        resultStr += "0";
      }
      resultStr += ".0";
    } else {
      const insertPos = resultStr.length + this.order;
      if (insertPos >= 0) {
        resultStr = resultStr.substring(0, insertPos) + "." + resultStr.substring(insertPos);
      } else {
        // If we need to insert before the start, pad with zeros
        const zerosNeeded = -insertPos;
        resultStr = "0." + "0".repeat(zerosNeeded) + resultStr;
      }

      // Remove trailing zeros
      while (resultStr.endsWith("0")) {
        resultStr = resultStr.substring(0, resultStr.length - 1);
      }
    }

    // Return with ellipsis at the beginning
    let startPos = 0;
    if (resultStr.length > this.precision + 1) {
      startPos = resultStr.length - this.precision - 1;
    }
    return " ..." + resultStr.substring(startPos);
  }

  // squareRootEvenPrime creates a 2-adic number which is the square root of the rational numerator/denominator
  squareRootEvenPrime(numerator, denominator) {
    if (modulo(numerator * denominator, 8) !== 1) {
      throw new Error("Number does not have a square root in 2-adic");
    }

    // First digit
    let sum = 1;
    this.digits.push(1);

    // Further digits
    const digitsSize = this.precision + 5;
    while (this.digits.length < digitsSize) {
      const factor = denominator * sum * sum - numerator;
      let valuation = 0;
      let factorTemp = factor;
      while (modulo(factorTemp, 2) === 0) {
        factorTemp = Math.floor(factorTemp / 2);
        valuation++;
      }

      sum += Math.pow(2, valuation - 1);

      while (this.digits.length < valuation - 1) {
        this.digits.push(0);
      }
      this.digits.push(1);
    }
  }

  // squareRootOddPrime creates a p-adic number, with an odd prime number, which is the p-adic square root
  squareRootOddPrime(numerator, denominator) {
    // First digit
    let firstDigit = 0;
    for (let i = 1; i < this.prime && firstDigit === 0; i++) {
      if (modulo(denominator * i * i - numerator, this.prime) === 0) {
        firstDigit = i;
      }
    }

    if (firstDigit === 0) {
      throw new Error(`Number does not have a square root in ${this.prime}-adic`);
    }

    this.digits.push(firstDigit);

    // Further digits
    const coefficient = moduloInverse(modulo(2 * denominator * firstDigit, this.prime), this.prime);
    let sum = firstDigit;
    const digitsSize = this.precision + 5;

    for (let i = 2; i < digitsSize; i++) {
      let nextSum = sum - coefficient * (denominator * sum * sum - numerator);
      nextSum = modulo(nextSum, Math.pow(this.prime, i));
      nextSum -= sum;
      sum += nextSum;

      const digit = Math.floor(nextSum / Math.pow(this.prime, i - 1));
      this.digits.push(digit);
    }
  }
}

// createPAdicSquareRoot creates a p-adic square root number from a rational number
function createPAdicSquareRoot(prime, precision, numerator, denominator) {
  if (denominator === 0) {
    throw new Error("Denominator cannot be zero");
  }

  const digitsSize = precision + 5;
  let order = 0;

  // Process rational zero
  if (numerator === 0) {
    return new PAdicSquareRoot(
      prime,
      precision,
      Array(digitsSize).fill(0),
      1000 // orderMax
    );
  }

  // Remove multiples of 'prime' and adjust the order accordingly
  while (modulo(numerator, prime) === 0) {
    numerator = Math.floor(numerator / prime);
    order++;
  }

  while (modulo(denominator, prime) === 0) {
    denominator = Math.floor(denominator / prime);
    order--;
  }

  if ((order & 1) !== 0) {
    throw new Error(`Number does not have a square root in ${prime}-adic`);
  }
  order >>= 1;

  const result = new PAdicSquareRoot(
    prime,
    precision,
    [],
    order
  );

  if (prime === 2) {
    result.squareRootEvenPrime(numerator, denominator);
  } else {
    result.squareRootOddPrime(numerator, denominator);
  }

  // Ensure we have the right number of digits
  while (result.digits.length < digitsSize) {
    result.digits.push(0);
  }
  if (result.digits.length > digitsSize) {
    result.digits = result.digits.slice(0, digitsSize);
  }

  return result;
}

// negateDigits transforms the given vector of digits representing a p-adic number
// into a vector which represents the negation of the p-adic number
function negateDigits(numbers, prime) {
  if (numbers.length > 0) {
    numbers[0] = modulo(prime - numbers[0], prime);
    for (let i = 1; i < numbers.length; i++) {
      numbers[i] = prime - 1 - numbers[i];
    }
  }
}

// multiplyDigits returns the list obtained by multiplying the digits of the given two lists
function multiplyDigits(one, two, prime, maxSize) {
  const product = Array(one.length + two.length).fill(0);

  for (let b = 0; b < two.length; b++) {
    let carry = 0;
    for (let a = 0; a < one.length; a++) {
      product[a + b] += one[a] * two[b] + carry;
      carry = Math.floor(product[a + b] / prime);
      product[a + b] %= prime;
    }
    if (b + one.length < product.length) {
      product[b + one.length] = carry;
    }
  }

  // Truncate to maxSize
  if (product.length > maxSize) {
    return product.slice(0, maxSize);
  }
  return product;
}

// moduloInverse returns the multiplicative inverse of the given number modulo 'prime'
function moduloInverse(number, prime) {
  let inverse = 1;
  while (modulo(inverse * number, prime) !== 1) {
    inverse++;
  }
  return inverse;
}

// modulo returns the given number modulo 'prime' in the range 0..'prime' - 1
function modulo(number, modulus) {
  const div = number % modulus;
  return div >= 0 ? div : div + modulus;
}

// Main function
function main() {
  const tests = [
    [2, 20, 497, 10496],
    [5, 14, 86, 25]
    // ,[7, 10, -19, 1]
  ];

  for (const test of tests) {
    console.log(`Number: ${test[2]} / ${test[3]} in ${test[0]}-adic`);

    try {
      const squareRoot = createPAdicSquareRoot(test[0], test[1], test[2], test[3]);

      console.log("The two square roots are:");
      console.log(`    ${squareRoot.toString()}`);
      console.log(`    ${squareRoot.negate().toString()}`);

      const square = squareRoot.multiply(squareRoot);
      console.log(`The p-adic value is ${square.toString()}`);

      const rational = square.convertToRational();
      console.log(`The rational value is ${rational}`);
    } catch (error) {
      console.log(`Error: ${error.message}`);
    }
    console.log();
  }
}

// Run the main function
main();
