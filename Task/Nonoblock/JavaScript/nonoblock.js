const compose = (...fn) => (...x) => fn.reduce((a, b) => c => a(b(c)))(...x);
const inv = b => !b;
const arrJoin = str => arr => arr.join(str);
const mkArr = (l, f) => Array(l).fill(f);
const sumArr = arr => arr.reduce((a, b) => a + b, 0);
const sumsTo = val => arr => sumArr(arr) === val;
const zipper = arr => (p, c, i) => arr[i] ? [...p, c, arr[i]] : [...p, c];
const zip = (a, b) => a.reduce(zipper(b), []);
const zipArr = arr => a => zip(a, arr);
const hasInner = v => arr => arr.slice(1, -1).indexOf(v) >= 0;
const choose = (even, odd) => n => n % 2 === 0 ? even : odd;
const toBin = f => arr => arr.reduce(
    (p, c, i) => [...p, ...mkArr(c, f(i))], []);


const looper = (arr, max, acc = [[...arr]], idx = 0) => {
  if (idx !== arr.length) {
    const b = looper([...arr], max, acc, idx + 1)[0];
    if (b[idx] !== max) {
      b[idx] = b[idx] + 1;
      acc.push(looper([...b], max, acc, idx)[0]);
    }
  }
  return [arr, acc];
};

const gapPerms = (grpSize, numGaps, minVal = 0) => {
  const maxVal = numGaps - grpSize * minVal + minVal;
  return maxVal <= 0
      ? (grpSize === 2 ? [[0]] : [])
      : looper(mkArr(grpSize, minVal), maxVal)[1];
}

const test = (cells, ...blocks) => {
  const grpSize = blocks.length + 1;
  const numGaps = cells - sumArr(blocks);

  // Filter functions
  const sumsToTrg = sumsTo(numGaps);
  const noInnerZero = compose(inv, hasInner(0));

  // Output formatting
  const combine = zipArr([...blocks]);
  const choices = toBin(choose(0, 1));
  const output = compose(console.log, arrJoin(''), choices, combine);

  console.log(`\n${cells} cells. Blocks: ${blocks}`);
  gapPerms(grpSize, numGaps)
      .filter(noInnerZero)
      .filter(sumsToTrg)
      .map(output);
};

test(5, 2, 1);
test(5);
test(5, 5);
test(5, 1, 1, 1);
test(10, 8);
test(15, 2, 3, 2, 3);
test(10, 4, 3);
test(5, 2, 3);
