// ---------------------------------------------------------------
//  Bell Triangle implementation (JavaScript)
// ---------------------------------------------------------------

class BellTriangle {
  /**
   * @param {number} n – number of rows to generate
   */
  constructor(n) {
    // total number of elements in a triangular array of size n
    const length = (n * (n + 1)) / 2;
    // use a plain array, pre‑filled with zeros
    this.arr = new Array(length).fill(0);

    // initialise first element (row 1, col 0) = 1
    this.set(1, 0, 1);

    // build the triangle row by row
    for (let i = 2; i <= n; ++i) {
      // first element of a row copies the last element of the previous row
      this.set(i, 0, this.get(i - 1, i - 2));

      // the remaining entries are sums of the element above‑left
      // and the element to the left in the current row
      for (let j = 1; j < i; ++j) {
        const value = this.get(i, j - 1) + this.get(i - 1, j - 1);
        this.set(i, j, value);
      }
    }
  }

  /** Convert (row, col) into a linear index. Rows start at 1. */
  index(row, col) {
    if (row > 0 && col >= 0 && col < row) {
      // triangular number formula: sum_{k=1}^{row-1} k = row*(row-1)/2
      return (row * (row - 1)) / 2 + col;
    }
    throw new Error('Invalid row/col');
  }

  /** Return the value at (row, col). */
  get(row, col) {
    const i = this.index(row, col);
    return this.arr[i];
  }

  /** Store `value` at (row, col). */
  set(row, col, value) {
    const i = this.index(row, col);
    this.arr[i] = value;
  }
}

// ---------------------------------------------------------------
//  Main program – reproduces the Java `main` method
// ---------------------------------------------------------------
(function main() {
  const rows = 15;
  const bt = new BellTriangle(rows);

  console.log('First fifteen Bell numbers:');
  for (let i = 0; i < rows; ++i) {
    // the Bell number Bₙ is the first entry of row n (row index = n, col = 0)
    console.log(`${i + 1}: ${bt.get(i + 1, 0)}`);
  }

  // Print the whole triangle for the first 10 rows (exactly as Java did)
  for (let i = 1; i <= 10; ++i) {
    let line = `${bt.get(i, 0)}`;
    for (let j = 1; j < i; ++j) {
      line += `, ${bt.get(i, j)}`;
    }
    console.log(line);
  }
})();
