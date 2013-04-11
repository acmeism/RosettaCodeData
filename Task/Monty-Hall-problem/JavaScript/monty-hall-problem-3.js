var totalGames = 10000,
    selectDoor = function () {
	return Math.floor(Math.random() * 3); // Choose a number from 0, 1 and 2.
    },
    games = (function () {
	var i = 0, games = [];

	for (; i < totalGames; ++i) {
	    games.push(selectDoor()); // Pick a door which will hide the prize.
	}

	return games;
    }()),
    play = function (switchDoor) {
	var i = 0, j = games.length, winningDoor, randomGuess, totalTimesWon = 0;

	for (; i < j; ++i) {
	    winningDoor = games[i];
	    randomGuess = selectDoor();
	    if ((randomGuess === winningDoor && !switchDoor) ||
		(randomGuess !== winningDoor && switchDoor))
	    {
		/*
		 * If I initially guessed the winning door and didn't switch,
		 * or if I initially guessed a losing door but then switched,
		 * I've won.
		 *
		 * The only time I lose is when I initially guess the winning door
		 * and then switch.
		 */

		totalTimesWon++;
	    }
	}
	return totalTimesWon;
    };

/*
 * Start the simulation
 */

console.log("Playing " + totalGames + " games");
console.log("Wins when not switching door", play(false));
console.log("Wins when switching door", play(true));
