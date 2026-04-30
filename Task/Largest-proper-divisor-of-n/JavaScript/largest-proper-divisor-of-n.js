function lpd(n) {
  if (n === 1) {
    return 1;
  }
  const lim = Math.floor(n / 2);
  for (let i = lim; i > 0; i--) {
    if (Number.isInteger(n / i)) {
      return i;
    }
  }
}

const a = [];
for (let i = 1; i < 101; i++) {
  a.push(lpd(i));
}

for (let i = 0; i < 10; i++) {
  console.log(a.slice(i * 10, (i + 1) * 10).join(" "));
}
