const readline = require('readline');

/**
 * Galton Box animation
 * @param {number} layers The number of layers in the board
 * @param {number} balls The number of balls to pass through
 */
const galtonBox = (layers, balls) => {
  const speed = 100;
  const ball = 'o';
  const peg = '.';
  const result = [];

  const sleep = ms => new Promise(resolve => {
    setTimeout(resolve,ms)
  });

  /**
   * The board is represented as a 2D array.
   * @type {Array<Array<string>>}
   */
  const board = [...Array(layers)]
      .map((e, i) => {
        const sides = Array(layers - i).fill(' ');
        const a = Array(i + 1).fill(peg).join(' ').split('');
        return [...sides, ...a, ...sides];
      });

  /**
   * @return {Array<string>}
   */
  const emptyRow = () => Array(board[0].length).fill(' ');

  /**
   * @param {number} i
   * @returns {number}
   */
  const bounce = i => Math.round(Math.random()) ? i - 1 : i + 1;

  /**
   * Prints the current state of the board and the collector
   */
  const show = () => {
    readline.cursorTo(process.stdout, 0, 0);
    readline.clearScreenDown(process.stdout);
    board.forEach(e => console.log(e.join('')));
    result.reverse();
    result.forEach(e => console.log(e.join('')));
    result.reverse();
  };


  /**
   * Collect the result.
   * @param {number} idx
   */
  const appendToResult = idx => {
    const row = result.find(e => e[idx] === ' ');
    if (row) {
      row[idx] = ball;
    } else {
      const newRow = emptyRow();
      newRow[idx] = ball;
      result.push(newRow);
    }
  };

  /**
   * Move the balls through the board
   * @returns {boolean} True if the there are balls in the board.
   */
  const iter = () => {
    let hasNext = false;
    [...Array(bordSize)].forEach((e, i) => {
      const rowIdx = (bordSize - 1) - i;
      const idx = board[rowIdx].indexOf(ball);
      if (idx > -1) {
        board[rowIdx][idx] = ' ';
        const nextRowIdx = rowIdx + 1;
        if (nextRowIdx < bordSize) {
          hasNext = true;
          const nextRow = board[nextRowIdx];
          nextRow[bounce(idx)] = ball;
        } else {
          appendToResult(idx);
        }
      }
    });
    return hasNext;
  };

  /**
   * Add a ball to the board.
   * @returns {number} The number of balls left to add.
   */
  const addBall = () => {
    board[0][apex] = ball;
    balls = balls - 1;
    return balls;
  };

  board.unshift(emptyRow());
  result.unshift(emptyRow());

  const bordSize = board.length;
  const apex = board[1].indexOf(peg);

  /**
   * Run the animation
   */
  (async () => {
    while (addBall()) {
      await sleep(speed).then(show);
      iter();
    }
    await sleep(speed).then(show);
    while (iter()) {
      await sleep(speed).then(show);
    }
    await sleep(speed).then(show);
  })();


};

galtonBox(12, 50);
