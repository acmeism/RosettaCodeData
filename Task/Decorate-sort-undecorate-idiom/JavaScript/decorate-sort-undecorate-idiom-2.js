function schwartzian(array, keyFn, compareFn) {
  const defaultCompareFn = (a, b) =>
    a[1] - b[1] || String(a[1]).localeCompare(String(b[1]));

  return array
    .map((e) => [e, keyFn(e)])
    .sort(compareFn || defaultCompareFn)
    .map((e) => e[0]);
}

const example = [
  "Rosetta",
  "Code",
  "is",
  "a",
  "programming",
  "chrestomathy",
  "site",
];

console.log(schwartzian(example, (e) => e.length));

// keyFn is the string in reverse
console.log(schwartzian(example, (e) => Array.from(e).reverse().join("")));
