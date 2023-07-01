Array.prototype.shuffle = function() {
  for (let i = this.length - 1; i > 0; i--) {
    let j = Math.floor(Math.random() * (i + 1));
    [this[i], this[j]] = [this[j], this[i]];
  }
}

function randomFEN() {

  let board = [];
  for (let x = 0; x < 8; x++) board.push('. . . . . . . .'.split(' '));

  function getRandPos() {
    return [Math.floor(Math.random() * 8), Math.floor(Math.random() * 8)];
  }

  function isOccupied(pos) {
    return board[pos[0]][pos[1]] != '.';
  }

  function isAdjacent(pos1, pos2) {
    if (pos1[0] == pos2[0] || pos1[0] == pos2[0]-1 || pos1[0] == pos2[0]+1)
    if (pos1[1] == pos2[1] || pos1[1] == pos2[1]-1 || pos1[1] == pos2[1]+1)
      return true;
    return false;
  }

  // place kings
  let wk, bk;
  do { wk = getRandPos(); bk = getRandPos(); }
  while (isAdjacent(wk, bk));
  board[wk[0]][wk[1]] = 'K';
  board[bk[0]][bk[1]] = 'k';

  // get peaces
  let peaces = [];
  let names = 'PRNBQ';
  function pick() {
    for (x = 1; x < Math.floor(Math.random() * 32); x++)
      peaces.push(names[Math.floor(Math.random() * names.length)]);
  }
  pick();
  names = names.toLowerCase();
  pick();
  peaces.shuffle();

  // place peaces
  while (peaces.length > 0) {
    let p = peaces.shift(), pos;
    // paws: cannot be placed in bottom or top row
    if (p == 'p' || p == 'P')
      do { pos = getRandPos() }
      while (isOccupied(pos) || pos[0] == 0 || pos[0] == 7);
    // everything else
    else do { pos = getRandPos(); } while (isOccupied(pos));
    board[pos[0]][pos[1]] = p;
  }

  // write FEN
  let fen = [];
  for (x = 0; x < board.length; x++) {
    let str ='', buf = 0;
    for (let y = 0; y < board[x].length; y++)
      if (board[x][y] == '.') buf++;
      else {
        if (buf > 0) { str += buf; buf = 0; }
        str += board[x][y];
      }
    if (buf > 0) str += buf;
    fen.push(str);
  }
  fen = fen.join('/') + ' w - - 0 1';
  console.table(board); // for demonstrating purpose
  return fen;
}

// example
console.log(randomFEN());
