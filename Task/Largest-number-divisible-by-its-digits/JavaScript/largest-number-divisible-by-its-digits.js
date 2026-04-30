function is_lynchbell(n) {
  const digits = [...String(n)].map(Number);
  if (digits.includes(0) || digits.includes(5)) {
    return false;
  }
  for (const d of digits) {
    if (digits.filter((x) => x == d).length > 1) {
      return false;
    } else if (!Number.isInteger(n / d)) {
      return false;
    }
  }
  return true;
}

for (let i = 9876432; i > 1; i--) {
  if (is_lynchbell(i)) {
    console.log(i);
    break;
  }
}
