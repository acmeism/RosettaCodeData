function is_square(n) {
  return Number.isInteger(Math.sqrt(n));
}

function is_subunit(n) {
  const s = [...String(n)].map(Number);
  if (s.includes(0) || s[0] === 1) {
    return false;
  }
  const nsub = Number(s.map(x => x - 1).join(""));
  if (is_square(n) && is_square(nsub)) {
    console.log(`${n} = ${Math.sqrt(n)}^2 and ${nsub} = ${Math.sqrt(nsub)}^2`);
    return true;
  }
  return false;
}

let count = 0, n = 1;
while (count < 4) {
  if (is_subunit(n)) {
    count++;
  }
  n++;
}
