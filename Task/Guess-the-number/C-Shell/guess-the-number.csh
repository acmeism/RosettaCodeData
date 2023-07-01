#!/bin/csh -f
# Guess the number

# jot(1) a random number. If jot(1) not found, exit now.
@ number = `jot -r 1 1 10` || exit

echo 'I have thought of a number. Try to guess it!'
echo 'Enter an integer from 1 to 10.'
@ guess = "$<"
while ( $guess != $number )
	echo 'Sorry, the guess was wrong! Try again!'
	@ guess = "$<"
end
echo 'Well done! You guessed it.'
