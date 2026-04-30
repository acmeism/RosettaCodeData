'use strict';

// ---------- helpers ----------
const gcd = (a, b) => {
  while (b !== 0) [a, b] = [b, a % b];
  return a;
};

// ---------- core logic ----------
function createDuffians(limit) {
  // divisor-sum table: divSum[i] = σ(i)
  const divSum = new Array(limit).fill(1);
  for (let i = 2; i < limit; ++i) {
    for (let j = i; j < limit; j += i) divSum[j] += i;
  }

  // mark non-Duffinians with 0
  divSum[1] = 0;                       // 1 is not Duffinian
  for (let n = 2; n < limit; ++n) {
    const s = divSum[n];
    if (s === n + 1 || gcd(n, s) !== 1) divSum[n] = 0;
  }
  return divSum;
}

// ---------- main ----------
const duffians = createDuffians(11_000);

console.log('The first 50 Duffinian numbers:');
let count = 0, n = 1;
while (count < 50) {
  if (duffians[n] > 0) {
    process.stdout.write(String(n).padStart(4) + (++count % 25 ? '' : '\n'));
  }
  ++n;
}
console.log();

console.log('The first 16 Duffinian triplets:');
count = 0;
n = 3;
while (count < 16) {
  if (duffians[n - 2] && duffians[n - 1] && duffians[n]) {
    const triplet = `(${n - 2}, ${n - 1}, ${n})`;
    process.stdout.write(triplet.padStart(22) + (++count % 4 ? '' : '\n'));
  }
  ++n;
}
console.log();
