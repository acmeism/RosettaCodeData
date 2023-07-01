/**
 * Boilerplate to simply get an array filled between 2 numbers
 * @param {!number} s Start here (inclusive)
 * @param {!number} e End here (inclusive)
 */
const makeArr = (s, e) => new Array(e + 1 - s).fill(s).map((e, i) => e + i);

/**
 * Remove every n-th element from the given array
 * @param {!Array} arr
 * @param {!number} n
 * @return {!Array}
 */
const filterAtInc = (arr, n) => arr.filter((e, i) => (i + 1) % n);

/**
 * Generate ludic numbers
 * @param {!Array} arr
 * @param {!Array} result
 * @return {!Array}
 */
const makeLudic = (arr, result) => {
  const iter = arr.shift();
  result.push(iter);
  return arr.length ? makeLudic(filterAtInc(arr, iter), result) : result;
};

/**
 * Our Ludic numbers. This is a bit of a cheat, as we already know beforehand
 * up to where our seed array needs to go in order to exactly get to the
 * 2005th Ludic number.
 * @type {!Array<!number>}
 */
const ludicResult = makeLudic(makeArr(2, 21512), [1]);


// Below is just logging out the results.
/**
 * Given a number, return a function that takes an array, and return the
 * count of all elements smaller than the given
 * @param {!number} n
 * @return {!Function}
 */
const smallerThanN = n => arr => {
  return arr.reduce((p,c) => {
    return c <= n ? p + 1 : p
  }, 0)
};
const smallerThan1K = smallerThanN(1000);

console.log('\nFirst 25 Ludic Numbers:');
console.log(ludicResult.filter((e, i) => i < 25).join(', '));

console.log('\nTotal Ludic numbers smaller than 1000:');
console.log(smallerThan1K(ludicResult));

console.log('\nThe 2000th to 2005th ludic numbers:');
console.log(ludicResult.filter((e, i) => i > 1998).join(', '));

console.log('\nTriplets smaller than 250:');
ludicResult.forEach(e => {
  if (e + 6 < 250 && ludicResult.indexOf(e + 2) > 0 && ludicResult.indexOf(e + 6) > 0) {
    console.log([e, e + 2, e + 6].join(', '));
  }
});
