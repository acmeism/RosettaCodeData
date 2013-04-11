function montyhall(tests, doors) {
	'use strict';
	tests = tests ? tests : 1000;
	doors = doors ? doors : 3;
	var prizeDoor, chosenDoor, shownDoor, switchDoor, chosenWins = 0, switchWins = 0;
	
	// randomly pick a door excluding input doors
	function pick(excludeA, excludeB) {
		var door;
		do {
			door = Math.floor(Math.random() * doors);
		} while (door === excludeA || door === excludeB);
		return door;
	}
	
	// run tests
	for (var i = 0; i < tests; i ++) {
		
		// pick set of doors
		prizeDoor = pick();
		chosenDoor = pick();
		shownDoor = pick(prizeDoor, chosenDoor);
		switchDoor = pick(chosenDoor, shownDoor);

		// test set for both choices
		if (chosenDoor === prizeDoor) {
			chosenWins ++;
		} else if (switchDoor === prizeDoor) {
			switchWins ++;
		}
	}
	
	// results
	return {
		stayWins: chosenWins + ' ' + (100 * chosenWins / tests) + '%',
		switchWins: switchWins + ' ' + (100 * switchWins / tests) + '%'
	};
}
