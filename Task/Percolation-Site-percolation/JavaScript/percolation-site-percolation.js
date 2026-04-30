class Grid {
  constructor(rowCount, colCount, probability) {
    this.EMPTY = " ";
    this.FILLED = ".";
    this.PATH = "#";
    this.table = this.createGrid(rowCount, colCount, probability);
  }

  createGrid(rowCount, colCount, probability) {
    const table = new Array(rowCount);
    for (let col = 0; col < rowCount; col++) {
      table[col] = new Array(colCount);
      for (let row = 0; row < colCount; row++) {
        table[col][row] = Math.random() < probability ? this.FILLED : this.EMPTY;
      }
    }
    return table;
  }

  percolate() {
    for (let x = 0; x < this.table[0].length; x++) {
      if (this.pathExists(x, 0)) {
        return true;
      }
    }
    return false;
  }

  pathExists(x, y) {
    if (
      y < 0 ||
      x < 0 ||
      x >= this.table[0].length ||
      this.table[y][x] !== this.FILLED
    ) {
      return false;
    }
    this.table[y][x] = this.PATH;
    if (y === this.table.length - 1) {
      return true;
    }
    return (
      this.pathExists(x, y + 1) ||
      this.pathExists(x + 1, y) ||
      this.pathExists(x - 1, y) ||
      this.pathExists(x, y - 1)
    );
  }

  display() {
    for (let col = 0; col < this.table.length; col++) {
      let rowStr = "";
      for (let row = 0; row < this.table[0].length; row++) {
        rowStr += " " + this.table[col][row];
      }
      console.log(rowStr);
    }
    console.log();
  }
}

function main() {
  const rowCount = 15;
  const colCount = 15;
  const testCount = 1000;

  const grid = new Grid(rowCount, colCount, 0.5);
  grid.percolate();
  grid.display();

  console.log(`Proportion of ${testCount} tests that percolate through the grid:`);
  for (let probable = 0.0; probable <= 1.0; probable += 0.1) {
    let percolationCount = 0;
    for (let test = 0; test < testCount; test++) {
      const testGrid = new Grid(rowCount, colCount, probable);
      if (testGrid.percolate()) {
        percolationCount += 1;
      }
    }
    const percolationProportion = percolationCount / testCount;
    console.log(` p = ${probable.toFixed(1)}: ${percolationProportion.toFixed(4)}`);
  }
}

main();
