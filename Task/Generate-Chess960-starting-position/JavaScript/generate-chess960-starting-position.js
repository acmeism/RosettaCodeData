function ch960startPos() {
  var rank = new Array(8),
      // randomizer (our die)
      d = function(num) { return Math.floor(Math.random() * ++num) },
      emptySquares = function() {
        var arr = [];
        for (var i = 0; i < 8; i++) if (rank[i] == undefined) arr.push(i);
        return arr;
      };
  // place one bishop on any black square
  rank[d(2) * 2] = "♗";
  // place the other bishop on any white square
  rank[d(2) * 2 + 1] = "♗";
  // place the queen on any empty square
  rank[emptySquares()[d(5)]] = "♕";
  // place one knight on any empty square
  rank[emptySquares()[d(4)]] = "♘";
  // place the other knight on any empty square
  rank[emptySquares()[d(3)]] = "♘";
  // place the rooks and the king on the squares left, king in the middle
  for (var x = 1; x <= 3; x++) rank[emptySquares()[0]] = x==2 ? "♔" : "♖";
  return rank;
}

// test
for (var x = 1; x <= 10; x++) console.log(ch960startPos().join(" | "));
