function is_palindrome(n) {
  return n == Number([...String(n)].toReversed().join(""));
}

function is_gapful(n) {
  const digits = [...String(n)].map(Number);
  const div = 10 * digits.shift() + digits.pop();
  return Number.isInteger(n / div);
}

for (let d = 2; d <= 9; d++) {
  console.log(`|Palindromic gapful numbers ending in ${d}|`);
  let nums = [], n = 100 + d;
  while (nums.length < 100) {
    if (is_gapful(n) && is_palindrome(n)) {
      nums.push(n);
    }
    n += 10;
  }
  console.log(`First 20: ${nums.slice(0, 20).join(" ")}`);
  console.log(`86th-100th: ${nums.slice(85, 100).join(" ")}`);
}
