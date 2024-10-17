##
function changes(amount: integer; coins: array of integer): int64;
begin
  var ways: array of int64;
  setLength(ways, amount + 1);
  ways[0] := 1;
  foreach var coin in coins do
    foreach var j in coin..amount do
      ways[j] += ways[j - coin];
  result := ways[amount]
end;

changes(100, |1, 5, 10, 25|).println;
changes(100000, |1, 5, 10, 25, 50, 100|).println;
