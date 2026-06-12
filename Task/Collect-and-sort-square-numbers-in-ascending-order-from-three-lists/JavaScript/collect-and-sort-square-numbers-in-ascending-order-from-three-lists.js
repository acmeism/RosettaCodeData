function is_square(n) {
  return Number.isInteger(Math.sqrt(n));
}

function concat_all(...args) {
  return args.reduce((x, y) => x.concat(y));
}

function numsort(arr) {
  return arr.toSorted((a, b) => a - b);
}

const arr1 = [3, 4, 34, 25, 9, 12, 36, 56, 36];
const arr2 = [2, 8, 81, 169, 34, 55, 76, 49, 7];
const arr3 = [75, 121, 75, 144, 35, 16, 46, 35];

console.log(numsort(concat_all(arr1, arr2, arr3).filter(is_square)));
