// Check if a number is prime (works with Number type)
function isPrime(n) {
  if (n < 2) return false;
  if (n % 2 === 0) return n === 2;
  if (n % 3 === 0) return n === 3;
  for (let p = 5; p * p <= n; p += 4) {
    if (n % p === 0) return false;
    p += 2;
    if (n % p === 0) return false;
  }
  return true;
}

// Rotate the digits of a number: 197 -> 719 -> 971
function cycle(n) {
  const s = n.toString();
  if (s.length === 1) return n;
  return parseInt(s.slice(1) + s[0], 10);
}

// Check if a number is a circular prime
function isCircularPrime(p) {
  if (!isPrime(p)) return false;

  // Quick check: multi-digit circular primes cannot contain 0,2,4,5,6,8
  const s = p.toString();
  if (s.length > 1 && /[024568]/.test(s)) return false;

  let p2 = cycle(p);
  while (p2 !== p) {
    if (p2 < p || !isPrime(p2)) return false;
    p2 = cycle(p2);
  }
  return true;
}

// Modular exponentiation: (base^exp) % mod
function powerMod(base, exp, mod) {
  let result = 1n;
  base = base % mod;
  while (exp > 0n) {
    if (exp % 2n === 1n) result = (result * base) % mod;
    exp >>= 1n;
    base = (base * base) % mod;
  }
  return result;
}

// Generate random BigInt in range [min, max] (inclusive)
function generateRandomBigInt(min, max) {
  if (max < min) throw new Error("Invalid range");

  const range = max - min + 1n;
  // If range is small enough, use Math.random
  if (range <= BigInt(Number.MAX_SAFE_INTEGER)) {
    return min + BigInt(Math.floor(Math.random() * Number(range)));
  }

  // For large ranges, generate a random number with appropriate digit length
  const maxStr = max.toString();
  const len = maxStr.length;

  let randomStr;
  do {
    // Generate a number with one fewer digit than max
    randomStr = '';
    for (let i = 0; i < len - 1; i++) {
      randomStr += Math.floor(Math.random() * 10).toString();
    }
    // Remove leading zeros and ensure it's not empty
    randomStr = randomStr.replace(/^0+/, '');
    if (randomStr === '') randomStr = '0';
  } while (BigInt(randomStr) > max);

  const result = BigInt(randomStr);
  return result >= min ? result : min;
}

// Miller-Rabin primality test for BigInt
function isProbablePrime(n, k = 15) {
  if (n === 2n || n === 3n) return true;
  if (n < 2n || n % 2n === 0n) return false;

  // Write n-1 as d*2^s
  let d = n - 1n;
  let s = 0;
  while (d % 2n === 0n) {
    d /= 2n;
    s++;
  }

  // Witness loop
  for (let i = 0; i < k; i++) {
    // Generate random BigInt a in range [2, n-2]
    const a = generateRandomBigInt(2n, n - 2n);

    let x = powerMod(a, d, n);
    if (x === 1n || x === n - 1n) continue;

    let composite = true;
    for (let r = 0; r < s - 1; r++) {
      x = (x * x) % n;
      if (x === n - 1n) {
        composite = false;
        break;
      }
    }

    if (composite) return false;
  }

  return true;
}

// Create a repunit: digits=3 -> 111n
function repunit(digits) {
  return (10n ** BigInt(digits) - 1n) / 9n;
}

// Test repunit primality
function testRepunit(digits) {
  const r = repunit(digits);
  if (isProbablePrime(r, 15)) {
    console.log(`R(${digits}) is probably prime.`);
  } else {
    console.log(`R(${digits}) is not prime.`);
  }
}

// Main execution
console.log("First 19 circular primes:");
let p = 2;
let count = 0;
while (count < 19) {
  if (isCircularPrime(p)) {
    if (count > 0) process.stdout.write(", ");
    process.stdout.write(p.toString());
    count++;
  }
  p++;
}
console.log();

console.log("Next 4 circular primes:");
let digits = 1;
let repunitVal = 1n;
while (repunitVal < BigInt(p)) {
  digits++;
  repunitVal = repunit(digits);
}

count = 0;
while (count < 4) {
  if (isProbablePrime(repunitVal, 15)) {
    if (count > 0) process.stdout.write(", ");
    process.stdout.write(`R(${digits})`);
    count++;
  }
  digits++;
  repunitVal = repunitVal * 10n + 1n;
}
console.log();

testRepunit(5003);
testRepunit(9887);
testRepunit(15073);
testRepunit(25031);
