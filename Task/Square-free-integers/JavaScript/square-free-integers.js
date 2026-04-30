function is_squarefree(n) {
  for (let i = 2; i <= Math.sqrt(n); i++) {
    if (Number.isInteger(n / (i ** 2))) {
      return false;
    }
  }
  return true;
}

for (const n of [1, 10 ** 12 + 1]) {
  console.log([...Array(145).keys()].map(x => x + n).filter(is_squarefree).join(" "));
}

let sqf = [];
for (let i = 1; i <= 1000000; i++) {
  if (is_squarefree(i)) {
    sqf.push(i);
  } else if (Number.isInteger(Math.log10(i))) {
    console.log(`There are ${sqf.length} square-free integers <=${i}`);
  }
}
