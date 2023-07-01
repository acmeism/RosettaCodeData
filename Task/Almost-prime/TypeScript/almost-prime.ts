// Almost prime

function isKPrime(n: number, k: number): bool {
  var f = 0;
  for (var i = 2; i <= n; i++)
    while (n % i == 0) {
      if (f == k)
        return false;
      ++f;
      n = Math.floor(n / i);
    }
  return f == k;
}

for (var k = 1; k <= 5; k++) {
  process.stdout.write(`k = ${k}:`);
  var i = 2, c = 0;
  while (c < 10) {
    if (isKPrime(i, k)) {
      process.stdout.write(" " + i.toString().padStart(3, ' '));
      ++c;
    }
    ++i;
  }
  console.log();
}
