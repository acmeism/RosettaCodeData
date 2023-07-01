#!/usr/bin/lasso9

local(
	lower	= integer_random(10, 1),
	higher	= integer_random(100, 20),
	number	= integer_random(#higher, #lower),
	status	= false,
	guess
)

// prompt for a number
stdout('Guess a number: ')

while(not #status) => {
	#guess = null

	// the following bits wait until the terminal gives you back a line of input
	while(not #guess or #guess -> size == 0) => {
		#guess = file_stdin -> readSomeBytes(1024, 1000)
	}
	#guess = integer(#guess)

	if(not (range(#guess, #lower, #higher) == #guess)) => {
		stdout('Input not of correct type or range. Guess a number: ')
	else(#guess > #number)
		stdout('That was to high, try again! ')
	else(#guess < #number)
		stdout('That was to low, try again! ')
	else(#guess == #number)
		stdout('Well guessed!')
		#status = true
	}
}
