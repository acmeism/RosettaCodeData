//-------------------------------------------[ Dancing Links and Algorithm X ]--
/**
 * The doubly-doubly circularly linked data object.
 * Data object X
 */
class DoX {
  /**
   * @param {string} V
   * @param {!DoX=} H
   */
  constructor(V, H) {
    this.V = V;
    this.L = this;
    this.R = this;
    this.U = this;
    this.D = this;
    this.S = 1;
    this.H = H || this;
    H && (H.S += 1);
  }
}

/**
 * Helper function to help build a horizontal doubly linked list.
 * @param {!DoX} e An existing node in the list.
 * @param {!DoX} n A new node to add to the right of the existing node.
 * @return {!DoX}
 */
const addRight = (e, n) => {
  n.R = e.R;
  n.L = e;
  e.R.L = n;
  return e.R = n;
};

/**
 * Helper function to help build a vertical doubly linked list.
 * @param {!DoX} e An existing node in the list.
 * @param {!DoX} n A new node to add below the existing node.
 */
const addBelow = (e, n) => {
  n.D = e.D;
  n.U = e;
  e.D.U = n;
  return e.D = n;
};

/**
 * Verbatim copy of DK's search algorithm. The meat of the DLX algorithm.
 * @param {!DoX} h The root node.
 * @param {!Array<!DoX>} s The solution array.
 */
const search = function(h, s) {
  if (h.R == h) {
    printSol(s);
  } else {
    let c = chooseColumn(h);
    cover(c);
    for (let r = c.D; r != c; r = r.D) {
      s.push(r);
      for (let j = r.R; r !=j; j = j.R) {
        cover(j.H);
      }
      search(h, s);
      r = s.pop();
      for (let j = r.R; j != r; j = j.R) {
        uncover(j.H);
      }
    }
    uncover(c);
  }
};

/**
 * Verbatim copy of DK's algorithm for choosing the next column object.
 * @param {!DoX} h
 * @return {!DoX}
 */
const chooseColumn = h => {
  let s = Number.POSITIVE_INFINITY;
  let c = h;
  for(let j = h.R; j != h; j = j.R) {
    if (j.S < s) {
      c = j;
      s = j.S;
    }
  }
  return c;
};


/**
 * Verbatim copy of DK's cover algorithm
 * @param {!DoX} c
 */
const cover = c => {
  c.L.R = c.R;
  c.R.L = c.L;
  for (let i = c.D; i != c; i = i.D) {
    for (let j = i.R; j != i; j = j.R) {
      j.U.D = j.D;
      j.D.U = j.U;
      j.H.S = j.H.S - 1;
    }
  }
};

/**
 * Verbatim copy of DK's cover algorithm
 * @param {!DoX} c
 */
const uncover = c => {
  for (let i = c.U; i != c; i = i.U) {
    for (let j = i.L; i != j; j = j.L) {
      j.H.S = j.H.S + 1;
      j.U.D = j;
      j.D.U = j;
    }
  }
  c.L.R = c;
  c.R.L = c;
};

//-----------------------------------------------------------[ Print Helpers ]--
/**
 * Given the standard string format of a grid, print a formatted view of it.
 * @param {!string|!Array} a
 */
const printGrid = function(a) {

  const getChar = c => {
    let r = Number(c);
    if (isNaN(r)) { return c }

    let o = 48;
    if (r > 9 && r < 36) { o = 55 }
    if (r >= 36) { o = 61 }
    return String.fromCharCode(r + o)
  };

  a = 'string' == typeof a ? a.split('') : a;

  let U = Math.sqrt(a.length);
  let N = Math.sqrt(U);
  let line = new Array(N).fill('+').reduce((p, c) => {
    p.push(... Array.from(new Array(1 + N*2).fill('-')));
    p.push(c);
    return p;
  }, ['\n+']).join('') + '\n';

  a = a.reduce(function(p, c, i) {
      let d = i && !(i % U), G = i && !(i % N);
      i = !(i % (U * N));
      d && !i && (p += '|\n| ');
      d && i && (p += '|');
      i && (p = '' + p + line + '| ');
      return '' + p + (G && !d ? '| ' : '') + getChar(c) + ' ';
    }, '') + '|' + line;
  console.log(a);

};

/**
 * Given a search solution, print the resultant grid.
 * @param {!Array<!DoX>} a An array of data objects
 */
const printSol = a => {
  printGrid(a.reduce((p, c) => {
    let [i, v] = c.V.split(':');
    p[i * 1] = v;
    return p;
  }, new Array(a.length).fill('.')));
};

//----------------------------------------------[ Grid to Exact cover Matrix ]--
/**
 * Helper to get some meta about the grid.
 * @param {!string} s The standard string representation of a grid.
 * @return {!Array}
 */
const gridMeta = s => {
  const g = s.split('');
  const cellCount = g.length;
  const tokenCount = Math.sqrt(cellCount);
  const N = Math.sqrt(tokenCount);
  const g2D = g.map(e => isNaN(e * 1) ?
    new Array(tokenCount).fill(1).map((_, i) => i + 1) :
    [e * 1]);
  return [cellCount, N, tokenCount, g2D];
};

/**
 * Given a cell grid index, return the row, column and box indexes.
 * @param {!number} n The n-value of the grid. 3 for a 9x9 sudoku.
 * @return {!function(!number): !Array<!number>}
 */
const indexesN = n => i => {
    let c = Math.floor(i / (n * n));
    i %= n * n;
    return [c, i, Math.floor(c / n) * n + Math.floor(i / n)];
};

/**
 * Given a puzzle string, reduce it to an exact-cover matrix and use
 * Donald Knuth's DLX algorithm to solve it.
 * @param puzString
 */
const reduceGrid = puzString => {

  printGrid(puzString);
  const [
    numCells,   // The total number of cells in a grid (81 for a 9x9 grid)
    N,          // the 'n' value of the grid. (3 for a 9x9 grid)
    U,          // The total number of unique tokens to be placed.
    g2D         // A 2D array representation of the grid, with each element
                // being an array of candidates for a cell. Known cells are
                // single element arrays.
  ] = gridMeta(puzString);

  const getIndex = indexesN(N);

  /**
   * The DLX Header row.
   * Its length is 4 times the grid's size. This is to be able to encode
   * each of the 4 Sudoku constrains, onto each of the cells of the grid.
   * The array is initialised with unlinked DoX nodes, but in the next step
   * those nodes are all linked.
   * @type {!Array.<!DoX>}
   */
  const headRow = new Array(4 * numCells)
    .fill('')
    .map((_, i) => new DoX(`H${i}`));

  /**
   * The header row root object. This is circularly linked to be to the left
   * of the first header object in the header row array.
   * It is used as the entry point into the DLX algorithm.
   * @type {!DoX}
   */
  let H = new DoX('ROOT');
  headRow.reduce((p, c) => addRight(p, c), H);

  /**
   * Transposed the sudoku puzzle into a exact cover matrix, so it can be passed
   * to the DLX algorithm to solve.
   */
  for (let i = 0; i < numCells; i++) {
    const [ri, ci, bi] = getIndex(i);
    g2D[i].forEach(num => {
      let id = `${i}:${num}`;
      let candIdx = num - 1;

      // The 4 columns that we will populate.
      const A = headRow[i];
      const B = headRow[numCells + candIdx + (ri * U)];
      const C = headRow[(numCells * 2) + candIdx + (ci * U)];
      const D = headRow[(numCells * 3) + candIdx + (bi * U)];

      // The Row-Column Constraint
      let rcc = addBelow(A.U, new DoX(id, A));

      // The Row-Number Constraint
      let rnc = addBelow(B.U, addRight(rcc, new DoX(id, B)));

      // The Column-Number Constraint
      let cnc = addBelow(C.U, addRight(rnc, new DoX(id, C)));

      // The Block-Number Constraint
      addBelow(D.U, addRight(cnc, new DoX(id, D)));
    });
  }
  search(H, []);
};
