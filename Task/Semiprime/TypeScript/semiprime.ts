// Semiprime

function primeFactorsCount(n: number): number {
  n = Math.abs(n);
  var count = 0; // Result
  if (n >= 2)
    for (factor = 2; factor <= n; factor++)
      while n % factor == 0) {
        count++;
        n /= factor;
      }
  return count;
}

const readline = require('readline').createInterface({
  input: process.stdin, output: process.stdout
});

readline.question('Enter an integer: ', sn => {
  var n = parseInt(sn);
  console.log(primeFactorsCount(n) == 2 ?
    "It is a semiprime." : "It is not a semiprime.");
  readline.close();
});
