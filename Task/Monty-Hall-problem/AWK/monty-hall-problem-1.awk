#!/bin/gawk -f

# Monty Hall problem

BEGIN {
	srand()
	doors = 3
	iterations = 10000
	# Behind a door:
	EMPTY = "empty"; PRIZE = "prize"
	# Algorithm used
  KEEP = "keep"; SWITCH="switch"; RAND="random";
  #
}
function monty_hall( choice, algorithm ) {
  # Set up doors
  for ( i=0; i<doors; i++ ) {
		door[i] = EMPTY
	}
  # One door with prize
	door[int(rand()*doors)] = PRIZE

  chosen = door[choice]
  del door[choice]

  #if you didn't choose the prize first time around then
  # that will be the alternative
	alternative = (chosen == PRIZE) ? EMPTY : PRIZE

	if( algorithm == KEEP) {
		return chosen
	}
	if( algorithm == SWITCH) {
		return alternative
	}
	return rand() <0.5 ? chosen : alternative
}

function simulate(algo){
	prizecount = 0
	for(j=0; j< iterations; j++){
		if( monty_hall( int(rand()*doors), algo) == PRIZE) {
			prizecount ++
		}
	}
	printf "  Algorithm %7s: prize count = %i, = %6.2f%%\n", \
		algo, prizecount,prizecount*100/iterations
}

BEGIN {
	print "\nMonty Hall problem simulation:"
	print doors, "doors,", iterations, "iterations.\n"
	simulate(KEEP)
	simulate(SWITCH)
	simulate(RAND)
		
}
