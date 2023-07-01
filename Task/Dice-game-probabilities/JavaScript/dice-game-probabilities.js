let Player = function(dice, faces) {
  this.dice = dice;
  this.faces = faces;
  this.roll = function() {
    let results = [];
    for (let x = 0; x < dice; x++)
      results.push(Math.floor(Math.random() * faces +1));
    return eval(results.join('+'));
  }
}

function contest(player1, player2, rounds) {
  let res = [0, 0, 0];
  for (let x = 1; x <= rounds; x++) {
    let a = player1.roll(),
        b = player2.roll();
    switch (true) {
      case (a > b): res[0]++; break;
      case (a < b): res[1]++; break;
      case (a == b): res[2]++; break;
    }
  }
  document.write(`
      <p>
        <b>Player 1</b> (${player1.dice} × d${player1.faces}): ${res[0]} wins<br>
        <b>Player 2</b> (${player2.dice} × d${player2.faces}): ${res[1]} wins<br>
        <b>Draws:</b> ${res[2]}<br>
        Chances for Player 1 to win:
        ~${Math.round(res[0] / eval(res.join('+')) * 100)} %
      </p>
  `);
}

let p1, p2;

p1 = new Player(9, 4),
p2 = new Player(6, 6);
contest(p1, p2, 1e6);

p1 = new Player(5, 10);
p2 = new Player(6, 7);
contest(p1, p2, 1e6);
