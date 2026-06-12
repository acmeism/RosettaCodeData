function schwartzian(array, keyFn) {
  return array
    .map((e) => [e, keyFn(e)])
    .sort((a, b) => a[1] - b[1])
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
