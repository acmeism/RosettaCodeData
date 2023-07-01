const alive = 1;
const dead = 0;

const conwaysGameOfLife = (game) => {
  const newGame = []
  for (let y = 0; y < game.length; y += 1) {
    const newRow = []
    for (let x = 0; x < game[y].length; x += 1) {
      const cell = game[y][x];
      const prevX = x > 0 ? x - 1 : x;
      const nextX = x < game[y].length - 1 ? x + 2 : x + 1;
      const counter =
        (game[y - 1] ? game[y - 1].slice(prevX, nextX).reduce((acc, v) => acc + v) : 0) +
        (game[y][x - 1] || 0) + (game[y][x + 1] || 0) +
        (game[y + 1] ? game[y + 1].slice(prevX, nextX).reduce((acc, v) => acc + v) : 0)
      cell === alive
        ? counter > 1 && counter <= 3
          ? newRow.push(alive)
          : newRow.push(dead)
        : counter === 3
          ? newRow.push(alive)
          : newRow.push(dead)
    }
    newGame.push(newRow)
  }
  return newGame
}

const generateGame = (height, width) => {
  return Array.from({ length: height }, (v, k) => (
    Array.from({ length: width}, (v, k) => {
      return (Math.random() * 100 | 0) < 50 ? dead : alive
    })
  ))
}

const output = (game) =>{
  process.stdout.write('\033c');
  let screen = '';
  for (let i = 0; i < game.length; i += 1) {
    screen += game[i].join('')
    screen += '\n'
  }
  console.log(screen)
}

const setup = ((game) => {
  return () => {
    setInterval(() => {
    output(game)
    const newGame = conwaysGameOfLife(game)
    game = newGame
    }, 1000)
  }
})

// for random game
// const game = generateGame(10, 10)

// glider test
const game = [
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,1,0,0,0,0,0,0,0],
  [0,0,0,1,0,0,0,0,0,0],
  [0,1,1,1,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0]
];
const run = setup(game);
run()
