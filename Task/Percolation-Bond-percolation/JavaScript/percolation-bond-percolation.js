// Constants
const ROW_COUNT = 10;
const COL_COUNT = 10;
const FILL = 1;
const RIGHT_WALL = 2;
const LOWER_WALL = 4;

// Global grid and endOfRow
let grid = new Array(COL_COUNT * (ROW_COUNT + 2)).fill(0);
let endOfRow = COL_COUNT;

// Random number generator
function random() {
  return Math.random();
}

// Create the grid with walls based on probability
function makeGrid(probability) {
  grid.fill(0);
  for (let i = 0; i < COL_COUNT; i++) {
    grid[i] = LOWER_WALL | RIGHT_WALL;
  }
  endOfRow = COL_COUNT;
  for (let i = 0; i < ROW_COUNT; i++) {
    for (let j = COL_COUNT - 1; j >= 1; j--) {
      const chance1 = random() < probability;
      const chance2 = random() < probability;
      grid[endOfRow++] = (chance1 ? LOWER_WALL : 0) | (chance2 ? RIGHT_WALL : 0);
    }
    const chance3 = random() < probability;
    grid[endOfRow++] = RIGHT_WALL | (chance3 ? LOWER_WALL : 0);
  }
}

// Display the grid in a readable format
function showGrid() {
  let output = "";
  for (let j = 0; j < COL_COUNT; j++) {
    output += "+--";
  }
  output += "+\n";

  for (let i = 0; i < ROW_COUNT; i++) {
    output += "|";
    for (let j = 0; j < COL_COUNT; j++) {
      const cell = grid[i * COL_COUNT + j + COL_COUNT];
      output += (cell & FILL) ? "[]" : "  ";
      output += (cell & RIGHT_WALL) ? "|" : " ";
    }
    output += "\n";

    for (let j = 0; j < COL_COUNT; j++) {
      const cell = grid[i * COL_COUNT + j + COL_COUNT];
      output += (cell & LOWER_WALL) ? "+--" : "+  ";
    }
    output += "+\n";
  }

  output += " ";
  for (let j = 0; j < COL_COUNT; j++) {
    const cell = grid[ROW_COUNT * COL_COUNT + j + COL_COUNT];
    output += (cell & FILL) ? "[]" : "  ";
    output += (cell & RIGHT_WALL) ? "|" : " ";
  }
  output += "\n\n";
  console.log(output);
}

// Iterative fill function using a stack
function fill(startIndex) {
  const stack = [startIndex];
  while (stack.length > 0) {
    const index = stack.pop();
    if ((grid[index] & FILL) !== 0) continue;
    grid[index] |= FILL;

    // Check if we've reached the bottom
    if (index >= grid.length - COL_COUNT) {
      return true;
    }

    // Push neighbors onto the stack
    if (index + COL_COUNT < grid.length && (grid[index] & LOWER_WALL) === 0) {
      stack.push(index + COL_COUNT);
    }
    if (index + 1 < grid.length && (grid[index] & RIGHT_WALL) === 0) {
      stack.push(index + 1);
    }
    if (index - 1 >= 0 && (grid[index - 1] & RIGHT_WALL) === 0) {
      stack.push(index - 1);
    }
    if (index - COL_COUNT >= 0 && (grid[index - COL_COUNT] & LOWER_WALL) === 0) {
      stack.push(index - COL_COUNT);
    }
  }
  return false;
}

// Percolate function
function percolate() {
  for (let i = 0; i < COL_COUNT; i++) {
    if (fill(COL_COUNT + i)) {
      return true;
    }
  }
  return false;
}

// Main simulation
console.log(`Sample percolation with a ${COL_COUNT} x ${ROW_COUNT} grid:`);
makeGrid(0.5);
percolate();
showGrid();

console.log("Using 10,000 repetitions for each probability p:");
for (let p = 1; p <= 9; p++) {
  let percolationCount = 0;
  const probability = p / 10.0;
  for (let i = 0; i < 10000; i++) {
    makeGrid(probability);
    if (percolate()) {
      percolationCount++;
    }
  }
  const percolationProportion = percolationCount / 10000;
  console.log(`p = ${probability.toFixed(1)}:  ${percolationProportion.toFixed(4)}`);
}
