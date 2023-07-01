let players = [
  { name: '', score: 0 },
  { name: '', score: 0 }
];
let curPlayer = 1,
    gameOver = false;

players[0].name = prompt('Your name, player #1:').toUpperCase();
players[1].name = prompt('Your name, player #2:').toUpperCase();

function roll() { return 1 + Math.floor(Math.random()*6) }

function round(player) {
  let curSum = 0,
      quit = false,
      dice;
  alert(`It's ${player.name}'s turn (${player.score}).`);
  while (!quit) {
      dice = roll();
      if (dice == 1) {
        alert('You roll a 1. What a pity!');
        quit = true;
      } else {
        curSum += dice;
        quit = !confirm(`
          You roll a ${dice} (sum: ${curSum}).\n
          Roll again?
        `);
        if (quit) {
          player.score += curSum;
          if (player.score >= 100) gameOver = true;
        }
      }
  }
}
// main
while (!gameOver) {
  if (curPlayer == 0) curPlayer = 1; else curPlayer = 0;
  round(players[curPlayer]);
  if (gameOver) alert(`
    ${players[curPlayer].name} wins (${players[curPlayer].score}).
  `);
}
