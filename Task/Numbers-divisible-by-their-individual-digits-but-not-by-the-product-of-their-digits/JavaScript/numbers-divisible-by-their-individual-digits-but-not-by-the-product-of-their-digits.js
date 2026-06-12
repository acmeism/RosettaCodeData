function divcond(n) {
  const digits = [...String(n)].map(Number);
  const prod = digits.reduce((x, y) => x * y);
  for (const d of digits) {
    if (!Number.isInteger(n / d)) {
      return false;
    }
  }
  return !Number.isInteger(n / prod);
}

console.log([...Array(1000).keys()].filter(divcond).join(" "));
