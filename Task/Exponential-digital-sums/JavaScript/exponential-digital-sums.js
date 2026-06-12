function digsum(n) {
  return [...String(n)].map(Number).reduce((x, y) => x + y);
}

function expdigsums(n, pmax) {
  const bign = BigInt(n);
  let pows = [];
  for (let i = 2n; i < BigInt(pmax); i++) {
    if (n == digsum(bign ** i)) {
      pows.push(`${n}^${Number(i)}`);
    }
  }
  return pows;
}

function find_expdigsums(lim, minways, pmax) {
  let n = 2, count = 0;
  while (count < lim) {
    const out = expdigsums(n, pmax);
    if (out.length >= minways) {
      console.log(out.join(", "));
      count++;
    }
    n++;
  }
}

console.log("First 20 integers with valid exponential digital sums:");
find_expdigsums(20, 1, 20);
console.log("First 10 that have three or more:");
find_expdigsums(10, 3, 100);
