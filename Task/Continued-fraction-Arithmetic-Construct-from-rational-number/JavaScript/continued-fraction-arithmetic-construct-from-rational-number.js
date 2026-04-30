function r2cf(n1, n2) {
  console.log(`Continued fraction representation of ${n1}/${n2}:`);
  let result = [];
  while (n2 !== 0) {
    let int = Math.trunc(n1 / n2);
    let rem = n1 % n2;
    result.push(int);
    n1 = n2;
    n2 = rem;
  }
  console.log(result.join(" "));
}

const test_fracs = [[1, 2], [3, 1], [23, 8], [13, 11], [22, 7], [-151, 77]];
for (const frac of test_fracs) {
  r2cf(...frac);
}

const rat_approx = (x, n) => [Math.floor(x * 10 ** n), 10 ** n];
for (const x of [Math.sqrt(2), 22 / 7]) {
  for (let i = 1; i <= 8; i++) {
    r2cf(...rat_approx(x, i));
  }
}
