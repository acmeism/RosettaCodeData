const compose = (...fn) => (...x) => fn.reduce((a, b) => c => a(b(c)))(...x);
const toString = x => x + '';
const reverse = x => Array.from(x).reduce((p, c) => [c, ...p], []);
const minBiggerThanN = (arr, n) => arr.filter(e => e > n).sort()[0];
const remEl = (arr, e) => {
  const r = arr.indexOf(e);
  return arr.filter((e,i) => i !== r);
}

const nextHighest = itr => {
  const seen = [];
  let result = 0;
  for (const [i,v] of itr.entries()) {
    const n = +v;
    if (Math.max(n, ...seen) !== n) {
      const right = itr.slice(i + 1);
      const swap = minBiggerThanN(seen, n);
      const rem = remEl(seen, swap);
      const rest = [n, ...rem].sort();
      result = [...reverse(right), swap, ...rest].join('');
      break;
    } else {
      seen.push(n);
    }
  }
  return result;
};

const check = compose(nextHighest, reverse, toString);

const test = v => {
  console.log(v, '=>', check(v));
}

test(0);
test(9);
test(12);
test(21);
test(12453);
test(738440);
test(45072010);
test(95322020);
test('9589776899767587796600');
