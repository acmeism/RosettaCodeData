// Sum digits of an integer

function sumOfDigitBase(n: number, bas: number): number {
  var digit = 0, sum = 0;
  while (n > 0)
  {
    var tmp = Math.floor(n / bas);
    digit = n - bas * tmp;
    n = tmp;
    sum += digit;
  }
  return sum;
}

console.log(`    1 sums to ${sumOfDigitBase(1, 10)}`);
console.log(` 1234 sums to ${sumOfDigitBase(1234, 10)}`);
console.log(` 0xfe sums to ${sumOfDigitBase(0xfe, 16)}`);
console.log(`0xf0e sums to ${sumOfDigitBase(0xf0e, 16)}`);
maxint = Number.MAX_SAFE_INTEGER;
console.log(`${maxint} (Number.MAX_SAFE_INTEGER) sums to ${sumOfDigitBase(maxint, 10)}`);
