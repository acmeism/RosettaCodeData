function is_odps(n) {
  const digits = [...String(n)].map(Number);
  const len = digits.length;
  return n == digits.map(x => x ** len).reduce((x, y) => x + y);
}

for (let i = 100; i < 100000000; i++) {
  if (is_odps(i)) {
    console.log(i);
  }
}
