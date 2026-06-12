function digit5thpowers(n) {
  return [...String(n)].map(s => Number(s) ** 5).reduce((x, y) => x + y);
}

let nums = [];
for (i = 2; i < 6 * 9 ** 5; i++) {
  if(i == digit5thpowers(i)) {
    nums.push(i);
  }
}

console.log(nums.reduce((x, y) => x + y));
