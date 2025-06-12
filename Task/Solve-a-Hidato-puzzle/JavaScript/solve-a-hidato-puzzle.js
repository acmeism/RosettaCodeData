let board = [];
let start = [];
let given = [];

function setup(input) {
  /* This task is not about input validation, so
     we're going to trust the input to be valid */
  const puzzle = input.map(line => line.split(/\s+/));
  const nCols = puzzle[0].length;
  const nRows = puzzle.length;
  let list = new Array(nRows * nCols);

  board = Array(nRows + 2).fill().map(() =>
    Array(nCols + 2).fill(-1)
  );

  for (let r = 0; r < nRows; r++) {
    const row = puzzle[r];
    for (let c = 0; c < nCols; c++) {
      const cell = row[c];
      switch (cell) {
        case "_":
          board[r + 1][c + 1] = 0;
          break;
        case ".":
          break;
        default:
          const val = parseInt(cell, 10);
          board[r + 1][c + 1] = val;
          list.push(val);
          if (val === 1) {
            start = [r + 1, c + 1];
          }
          break;
      }
    }
  }

  list.sort((a, b) => a - b);
  given = [...list];
}

function solve(r, c, n, next) {
  if (n > given[given.length - 1]) {
    return true;
  }

  const back = board[r][c];
  if (back !== 0 && back !== n) {
    return false;
  }

  if (back === 0 && given[next] === n) {
    return false;
  }

  if (back === n) {
    next++;
  }

  board[r][c] = n;
  for (let i = -1; i < 2; i++) {
    for (let j = -1; j < 2; j++) {
      if (solve(r + i, c + j, n + 1, next)) {
        return true;
      }
    }
  }

  board[r][c] = back;
  return false;
}

function printBoard() {
  for (const row of board) {
    let rowStr = '';
    for (const c of row) {
      switch (true) {
        case c === -1:
          rowStr += ' . ';
          break;
        case c > 0:
          rowStr += c.toString().padStart(2) + ' ';
          break;
        default:
          rowStr += '__ ';
          break;
      }
    }
    console.log(rowStr);
  }
}

function main() {
  const input = [
    "_ 33 35 _ _ . . .",
    "_ _ 24 22 _ . . .",
    "_ _ _ 21 _ _ . .",
    "_ 26 _ 13 40 11 . .",
    "27 _ _ _ 9 _ 1 .",
    ". . _ _ 18 _ _ .",
    ". . . . _ 7 _ _",
    ". . . . . . 5 _"
  ];

  setup(input);
  printBoard();
  console.log("\nFound:");
  solve(start[0], start[1], 1, 0);
  printBoard();
}

main();
