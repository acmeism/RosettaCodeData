function collatz_isself(n) {
  const init = n;
  while (n > 1) {
    n = Number.isInteger(n / 2) ? n / 2 : 3 * n + 1;
    if (Number.isInteger(n / init)) {
      return true;
    }
  }
  return false;
}

let count = 0, num = 1;
while (count < 7) {
  if (collatz_isself(num)) {
    count++;
    console.log(num);
  }
  num += 2;
}
