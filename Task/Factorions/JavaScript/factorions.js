function factorial(n) {
  if (n <= 1) {
    return 1;
  }
  let a = [...Array(n + 1).keys()];
  a.shift();
  return a.reduce((x, y) => x * y);
}

function fact_digsum(n, b) {
  if (n > b - 1) {
    return factorial(n % b) + fact_digsum(Math.floor(n / b), b);
  }
  return factorial(n);
}

for (let i = 9; i <= 12; i++) {
  console.log(`Factorions in base ${i}:`);
  for (let j = 1; j < 1499999; j++) {
    if (j == fact_digsum(j, i)) {
      console.log(j);
    }
  }
  console.log();
}
