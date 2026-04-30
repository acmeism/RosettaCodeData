"use strict";

function mod(n, m) {
  return ((n % m) + m) % m;
}

function isPrime(n) {
  if (n === 2 || n === 3) return true;
  if (n < 2 || n % 2 === 0 || n % 3 === 0) return false;
  for (let div = 5, inc = 2; div * div <= n; div += inc, inc = 6 - inc) {
    if (n % div === 0) return false;
  }
  return true;
}

// emulate Java's integer division (truncation toward zero)
function idiv(a, b) {
  return Math.trunc(a / b);
}

function main() {
  for (let p = 2; p < 62; p++) {
    if (!isPrime(p)) continue;

    for (let h3 = 2; h3 < p; h3++) {
      const g = h3 + p;

      for (let d = 1; d < g; d++) {
        if ((g * (p - 1)) % d !== 0 || mod(-p * p, h3) !== d % h3) continue;

        const q = 1 + idiv((p - 1) * g, d);
        if (!isPrime(q)) continue;

        const r = 1 + idiv(p * q, h3);
        if (!isPrime(r) || (q * r) % (p - 1) !== 1) continue;

        console.log(`${p} x ${q} x ${r}`);
      }
    }
  }
}

main();
