RANDOMIZE TIMER
DIM doors(3) '0 is a goat, 1 is a car
CLS
switchWins = 0
stayWins = 0
FOR plays = 0 TO 32767
	winner = INT(RND * 3) + 1
	doors(winner) = 1'put a winner in a random door
	choice = INT(RND * 3) + 1'pick a door, any door
	DO
		shown = INT(RND * 3) + 1
	'don't show the winner or the choice
	LOOP WHILE doors(shown) = 1 OR shown = choice
	stayWins = stayWins + doors(choice) 'if you won by staying, count it
	switchWins = switchWins + doors(3 - choice - shown) 'could have switched to win
	doors(winner) = 0 'clear the doors for the next test
NEXT plays
PRINT "Switching wins"; switchWins; "times."
PRINT "Staying wins"; stayWins; "times."
