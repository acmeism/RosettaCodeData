// Board
const topLeft = 1;
const topMid = 2;
const topRight = 3;
const midLeft = 4;
const center = 5;
const midRight = 6;
const botLeft = 7;
const botMid = 8;
const botRight = 9;
const tiles = [
  topLeft, topMid, topRight,
  midLeft, center, midRight,
  botLeft, botMid, botRight
];
const corners = [
  topLeft, topRight,
  botLeft, botRight
];
const sides = [
  topMid,
  midLeft, midRight,
  botMid
];
const winningCombos = [
  [topLeft, topMid, topRight],
  [midLeft, center, midRight],
  [botLeft, botMid, botRight],
  [topLeft, midLeft, botLeft],
  [topMid, center, botMid],
  [topRight, midRight, botRight],
  [topLeft, center, botRight],
  [topRight, center, botLeft],
];
const board = new Map();

// Utility
const reset = () => tiles.forEach(e => board.set(e, ' '));
const repeat = (s, n) => Array(n).fill(s).join('');
const fromBoard = e => board.get(e);
const notSpace = e => e !== ' ';
const occupied = e => notSpace(fromBoard(e));
const isAvailable = e => !occupied(e);
const notString = s => e => fromBoard(e) !== s;
const containsOnly = s => a => a.filter(occupied).map(fromBoard).join('') === s;
const chooseRandom = a => a[Math.floor(Math.random() * a.length)];
const legalPlays = () => tiles.filter(isAvailable);
const legalCorners = () => corners.filter(isAvailable);
const legalSides = () => sides.filter(isAvailable);
const opponent = s => s === 'X' ? 'O' : 'X';
const hasElements = a => a.length > 0;
const compose = (...fns) => (...x) => fns.reduce((a, b) => c => a(b(c)))(...x);
const isDef = t => t !== undefined;
const flatten = a => a.reduce((p, c) => [...p, ...c], []);

const findShared = a => [...flatten(a).reduce((p, c) =>
        p.has(c) ? p.set(c, [...p.get(c), c]) : p.set(c, [c]),
    new Map()).values()].filter(e => e.length > 1).map(e => e[0]);

const wrap = (f, s, p = 9) => n => {
  if (isDef(n) || legalPlays().length > p) {
    return n;
  }
  const r = f(n);
  if (isDef(r)) {
    console.log(`${s}: ${r}`);
  }
  return r;
};

const drawBoard = () => console.log(`
  ${[fromBoard(topLeft), fromBoard(topMid), fromBoard(topRight)].join('|')}
  -+-+-
  ${[fromBoard(midLeft), fromBoard(center), fromBoard(midRight)].join('|')}
  -+-+-
  ${[fromBoard(botLeft), fromBoard(botMid), fromBoard(botRight)].join('|')}
`);

const win = s => () => {
  if (winningCombos.find(containsOnly(repeat(s, 3)))) {
    console.log(`${s} wins!`);
    reset()
  } else if (hasElements(legalPlays())) {
    console.log(`${opponent(s)}s turn:`);
  } else {
    console.log('Draw!');
    reset();
  }
};

const play = s => n => occupied(n) ? console.log('Illegal') : board.set(n, s);


// Available strategy steps
const attack = (s, t = 2) => () => {
  const m = winningCombos.filter(containsOnly(repeat(s, t)));
  if (hasElements(m)) {
    return chooseRandom(chooseRandom(m).filter(notString(s)))
  }
};

const fork = (s, isDefence = false) => () => {
  let result;
  const p = winningCombos.filter(containsOnly(s));
  const forks = findShared(p).filter(isAvailable);

  // On defence, when there is only one fork, play it, else choose a
  // two-in-a row attack to force the opponent to not execute the fork.
  if (forks.length > 1 && isDefence) {
    const me = opponent(s);
    const twoInRowCombos = winningCombos.filter(containsOnly(repeat(me, 1)));
    const chooseFrom = twoInRowCombos.reduce((p, a) => {
      const avail = a.filter(isAvailable);
      avail.forEach((e, i) => {
        board.set(e, me).set(i ? avail[i - 1] : avail[i + 1], opponent(me));
        winningCombos.filter(containsOnly(repeat(s, 2))).length < 2
            ? p.push(e)
            : undefined;
      });
      avail.forEach(e => board.set(e, ' '));
      return p;
    }, []);
    result = hasElements(chooseFrom)
        ? chooseRandom(chooseFrom)
        : attack(opponent(s), 1)()
  }
  return result || chooseRandom(forks);
};

const defend = (s, t = 2) => attack(opponent(s), t);

const defendFork = s => fork(opponent(s), true);

const chooseCenter = () => isAvailable(center) ? center : undefined;

const chooseCorner = () => chooseRandom(legalCorners());

const chooseSide = () => chooseRandom(legalSides());

const randLegal = () => chooseRandom(legalPlays());

// Implemented strategy
const playToWin = s => compose(
    win(s),
    drawBoard,
    play(s),
    wrap(randLegal, 'Chose random'),
    wrap(chooseSide, 'Chose random side', 8),
    wrap(chooseCorner, 'Chose random corner', 8),
    wrap(chooseCenter, 'Chose center', 7),
    wrap(defendFork(s), 'Defended fork'),
    wrap(fork(s), 'Forked'),
    wrap(defend(s), 'Defended'),
    wrap(attack(s), 'Attacked')
);

// Prep players
const O = n => playToWin('O')(n);
const X = n => playToWin('X')(n);

// Begin
reset();
console.log("Let's begin...");
drawBoard();
console.log('X Begins: Enter a number from 1 - 9');

// Manage user input.
const standard_input = process.stdin;
const overLog = s => {
  process.stdout.moveCursor(0, -9);
  process.stdout.cursorTo(0);
  process.stdout.clearScreenDown();
  process.stdout.write(s);
};
standard_input.setEncoding('utf-8');
standard_input.on('data', (data) => {
  if (data === '\n') {
    overLog('O: ');
    O();
  } else {
    overLog(`X: Plays ${data}`);
    X(Number(data));
  }
});
