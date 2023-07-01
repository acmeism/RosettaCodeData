local(
	number	= integer_random(10, 1),
	status	= false,
	guess
)

// prompt for a number
stdout('Guess a number between 1 and 10: ')

while(not #status) => {
	#guess = null

	// the following bits wait until the terminal gives you back a line of input
	while(not #guess or #guess -> size == 0) => {
		#guess = file_stdin -> readSomeBytes(1024, 1000)
	}
	#guess = integer(#guess)

	if(not (range(#guess, 1, 10) == #guess)) => {
		stdout('Input not of correct type or range. Guess a number between 1 and 10: ')
	else(#guess == #number)
		stdout('Well guessed!')
		#status = true
	else
		stdout('You guessed wrong number. Guess a number between 1 and 10: ')
	}

}
