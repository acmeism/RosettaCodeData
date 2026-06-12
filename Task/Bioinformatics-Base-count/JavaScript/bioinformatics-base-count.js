const rowLength = 50;

const bases = ['A', 'C', 'G', 'T'];

// Create the starting sequence
const seq = `CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG
CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG
AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT
GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT
CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG
TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA
TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT
CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG
TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC
GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT`
    .split('')
    .filter(e => bases.includes(e))

/**
 * Convert the given array into an array of smaller arrays each with the length
 * given by n.
 * @param {number} n
 * @returns {function(!Array<*>): !Array<!Array<*>>}
 */
const chunk = n => a => a.reduce(
    (p, c, i) => (!(i % n)) ? p.push([c]) && p : p[p.length - 1].push(c) && p,
    []);
const toRows = chunk(rowLength);

/**
 * Given a number, return function that takes a string and left pads it to n
 * @param {number} n
 * @returns {function(string): string}
 */
const padTo = n => v => ('' + v).padStart(n, ' ');
const pad = padTo(5);

/**
 * Count the number of elements that match the given value in an array
 * @param {Array<string>} arr
 * @returns {function(string): number}
 */
const countIn = arr => s => arr.filter(e => e === s).length;

/**
 * Utility logging function
 * @param {string|number} v
 * @param {string|number} n
 */
const print = (v, n) => console.log(`${pad(v)}:\t${n}`)

const prettyPrint = seq => {
  const chunks = toRows(seq);
  console.log('SEQUENCE:')
  chunks.forEach((e, i) => print(i * rowLength, e.join('')))
}

const printBases = (seq, bases) => {
  const filterSeq = countIn(seq);
  const counts = bases.map(filterSeq);
  console.log('\nBASE COUNTS:')
  counts.forEach((e, i) => print(bases[i], e));
  print('Total', counts.reduce((p,c) => p + c, 0));
}

prettyPrint(seq);
printBases(seq, bases);
