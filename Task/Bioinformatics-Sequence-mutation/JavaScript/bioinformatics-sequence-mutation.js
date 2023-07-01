// Basic set-up
const numBases = 250
const numMutations = 30
const bases = ['A', 'C', 'G', 'T'];

// Utility functions
/**
 * Return a shallow copy of an array
 * @param {Array<*>} arr
 * @returns {*[]}
 */
const copy = arr => [...arr];

/**
 * Get a random int up to but excluding the the given number
 * @param {number} max
 * @returns {number}
 */
const randTo = max => (Math.random() * max) | 0;

/**
 * Given an array return a random element and the index of that element from
 * the array.
 * @param {Array<*>} arr
 * @returns {[*[], number]}
 */
const randSelect = arr => {
  const at = randTo(arr.length);
  return [arr[at], at];
};

/**
 * Given a number or string, return a left padded string
 * @param {string|number} v
 * @returns {string}
 */
const pad = v => ('' + v).padStart(4, ' ');

/**
 * Count the number of elements that match the given value in an array
 * @param {Array<string>} arr
 * @returns {function(string): number}
 */
const filterCount = arr => s => arr.filter(e => e === s).length;

/**
 * Utility logging function
 * @param {string|number} v
 * @param {string|number} n
 */
const print = (v, n) => console.log(`${pad(v)}:\t${n}`)

/**
 * Utility function to randomly select a new base, and an index in the given
 * sequence.
 * @param {Array<string>} seq
 * @param {Array<string>} bases
 * @returns {[string, string, number]}
 */
const getVars = (seq, bases) => {
  const [newBase, _] = randSelect(bases);
  const [extBase, randPos] = randSelect(seq);
  return [newBase, extBase, randPos];
};

// Bias the operations
/**
 * Given a map of function to ratio, return an array of those functions
 * appearing ratio number of times in the array.
 * @param weightMap
 * @returns {Array<function>}
 */
const weightedOps = weightMap => {
  return [...weightMap.entries()].reduce((p, [op, weight]) =>
      [...p, ...(Array(weight).fill(op))], []);
};

// Pretty Print functions
const prettyPrint = seq => {
  let idx = 0;
  const rem = seq.reduce((p, c) => {
    const s = p + c;
    if (s.length === 50) {
      print(idx, s);
      idx = idx + 50;
      return '';
    }
    return s;
  }, '');
  if (rem !== '') {
    print(idx, rem);
  }
}

const printBases = seq => {
  const filterSeq = filterCount(seq);
  let tot = 0;
  [...bases].forEach(e => {
    const cnt = filterSeq(e);
    print(e, cnt);
    tot = tot + cnt;
  })
  print('Σ', tot);
}

// Mutation definitions
const swap = ([hist, seq]) => {
  const arr = copy(seq);
  const [newBase, extBase, randPos] = getVars(arr, bases);
  arr.splice(randPos, 1, newBase);
  return [[...hist, `Swapped ${extBase} for ${newBase} at ${randPos}`], arr];
};

const del = ([hist, seq]) => {
  const arr = copy(seq);
  const [newBase, extBase, randPos] = getVars(arr, bases);
  arr.splice(randPos, 1);
  return [[...hist, `Deleted ${extBase} at ${randPos}`], arr];
}

const insert = ([hist, seq]) => {
  const arr = copy(seq);
  const [newBase, extBase, randPos] = getVars(arr, bases);
  arr.splice(randPos, 0, newBase);
  return [[...hist, `Inserted ${newBase} at ${randPos}`], arr];
}

// Create the starting sequence
const seq = Array(numBases).fill(undefined).map(
    () => randSelect(bases)[0]);

// Create a weighted set of mutations
const weightMap = new Map()
    .set(swap, 1)
    .set(del, 1)
    .set(insert, 1);
const operations = weightedOps(weightMap);
const mutations = Array(numMutations).fill(undefined).map(
    () => randSelect(operations)[0]);

// Mutate the sequence
const [hist, mut] = mutations.reduce((p, c) => c(p), [[], seq]);

console.log('ORIGINAL SEQUENCE:')
prettyPrint(seq);

console.log('\nBASE COUNTS:')
printBases(seq);

console.log('\nMUTATION LOG:')
hist.forEach((e, i) => console.log(`${i}:\t${e}`));

console.log('\nMUTATED SEQUENCE:')
prettyPrint(mut);

console.log('\nMUTATED BASE COUNTS:')
printBases(mut);
