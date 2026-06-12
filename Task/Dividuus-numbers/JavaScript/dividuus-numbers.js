function dreduce(f, n) {
  return [...String(n)].map(Number).reduce(f);
}

function digsum(n) {
  return dreduce((x, y) => x + y, n);
}

function digmul(n) {
  return dreduce((x, y) => x * y, n);
}

function diterate(f, n) {
  while (n > 9) {
    n = f(n);
  }
  return n;
}

function digroot(n) {
  return diterate(digsum, n);
}

function mdigroot(n) {
  return diterate(digmul, n);
}

function is_dividuus(n) {
  const divisors = [digsum(n), digmul(n), digroot(n), mdigroot(n)];
  for (const div of divisors) {
    if (!Number.isInteger(n / div)) {
      return false;
    }
  }
  return true;
}

let n = 1;
let a = [];
while (a.length < 50) {
  if (is_dividuus(n)) {
    a.push(n);
  }
  n++;
}

console.log(a.join(" "));
