// De Polignac numbers

const maxPower = 20, maxNumber = 500000;
var powersOf2 = new Array(maxPower + 1);
var prime = new Array(maxNumber + 1);
// Sieve the primes to maxNumber
prime[0] = false;
prime[1] = false;
prime[2] = true;
for (i = 3; i <= maxNumber; i += 2)
  prime[i] = true;
for (i = 4; i <= maxNumber; i += 2)
  prime[i] = false;
sqrtMaxNumber = Math.floor(Math.sqrt(maxNumber));
for (i = 3; i <= sqrtMaxNumber; i += 2) {
  if (prime[i]) {
    let dblI = i + i;
    for (var s = i * i; s <= maxNumber; s += dblI)
      prime[s] = false;
  }
}

// Table of powers of 2 greater than 2^0 (up to around 2000000)
// Increase the table size IF maxNumber > 2000000
let p2 = 1;
for (i = 1; i <= maxPower; i++) {
  p2 *= 2;
  powersOf2[i] = p2;
}
// The numbers must be odd and not of the form p + 2^n
// either p is odd and 2^n is even and hence n > 0 and p > 2
// or 2^n is odd and p is even and hence n = 0 and p = 2
// (the only even prime is 2, the only odd 2^n is 1)
// n = 0, p = 2
var dpCount = 1;
var outStr = "    1";
// n > 0, p > 2;
for (i = 5; i <= maxNumber; i += 2) {
  let found = false;
  let p = 1;
  while (p <= maxPower && !found && i > powersOf2[p]) {
    found = prime[i - powersOf2[p]];
    p++;
  }
  if (!found) {
    dpCount++;
    if (dpCount <= 50) {
      outStr += i.toString().padStart(5, ' ');
      if (dpCount % 10 == 0) {
        console.log(outStr);
        outStr = "";
      }
    }
  }
}
console.log("Found " + dpCount + " de Polignac numbers up to " + maxNumber);
