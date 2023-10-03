use Random;

config const numGames = 100_000_000;

var switch, stick: uint;

// have a separate RNG for each task; add together the results at the end
forall i in 1..numGames
  with (var rand = new RandomStream(uint, parSafe = false), + reduce stick)
{
  var chosen_door = rand.getNext() % 3;
  var winner_door = rand.getNext() % 3;
  if chosen_door == winner_door then
    stick += 1;
}

// if you lost by sticking it means you would have won by switching
switch = numGames - stick;
writeln("Over ", numGames, " games:\n - switching wins ",
        100.0*switch / numGames, "% of the time and\n - sticking  wins ",
        100.0*stick  / numGames, "% of the time");
