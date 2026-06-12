function gen_palindrome(n) {
  const digits = [...String(n)];
  return Number(digits.concat(digits.toReversed()).join(""));
}

function lpp(d) {
  const lim = 10 ** d;
  for (let i = lim - 1; i > lim / 10 - 1; i--) {
    const p = gen_palindrome(i);
    for (let j = lim - 1; j > lim / 10 - 1; j--) {
      const k = p / j;
      if (Number.isInteger(k) && k < lim) {
        return(`Largest palindromic product of two ${d}-digit numbers: ${p} = ${j} * ${k}`);
      }
    }
  }
}

for (let i = 2; i < 8; i++) {
  console.log(lpp(i));
}
