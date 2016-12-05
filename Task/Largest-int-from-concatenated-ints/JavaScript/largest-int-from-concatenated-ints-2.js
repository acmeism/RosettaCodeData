var maxCombine = (a) => +(a.sort((x, y) => +("" + y + x) - +("" + x + y)).join(''));

// test & output
console.log([
  [1, 34, 3, 98, 9, 76, 45, 4],
  [54, 546, 548, 60]
].map(maxCombine));
