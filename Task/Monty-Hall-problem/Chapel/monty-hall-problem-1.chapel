use Random;

param doors: int = 3;
config const games: int = 1000;

config const maxTasks = 32;
var numTasks = 1;
while( games / numTasks > 1000000 && numTasks < maxTasks ) do numTasks += 1;
const tasks = 1..#numTasks;
const games_per_task = games / numTasks ;
const remaining_games = games % numTasks ;

var wins_by_stay: [tasks] int;

coforall task in tasks {

  var rand = new  RandomStream();

  for game in 1..#games_per_task {
    var player_door =  (rand.getNext() * 1000): int % doors ;
    var winning_door = (rand.getNext() * 1000): int % doors ;
    if player_door == winning_door then
      wins_by_stay[ task ] += 1;
  }

  if task == tasks.last then {
    for game in 1..#remaining_games {
      var player_door =  (rand.getNext() * 1000): int % doors ;
      var winning_door = (rand.getNext() * 1000): int % doors ;
      if player_door == winning_door then
        wins_by_stay[ task ] += 1;
    }
  }

}

var total_by_stay = + reduce wins_by_stay;

var total_by_switch = games - total_by_stay;
var percent_by_stay = ((total_by_stay: real) / games) * 100;
var percent_by_switch = ((total_by_switch: real) / games) * 100;

writeln( "Wins by staying: ", total_by_stay, " or ", percent_by_stay, "%" );
writeln( "Wins by switching: ", total_by_switch, " or ", percent_by_switch, "%" );
if ( total_by_stay > total_by_switch ){
  writeln( "Staying is the superior method." );
} else if( total_by_stay < total_by_switch ){
  writeln( "Switching is the superior method." );
} else {
  writeln( "Both methods are equal." );
}
