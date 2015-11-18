-- defining the range of the number to be guessed
property minLimit : 1
property maxLimit : 100

on run
	-- ask the user to think of  a number in the given range
	display dialog "Please think of a number between " & minLimit & " and " & maxLimit
	
	-- prepare a variable for the lowest guessed value	
	set lowGuess to minLimit
	-- prepare a variable for the highest guessed value	
	set highGuess to maxLimit
	
	repeat
		-- guess a number inside the logical range
		set computersGuess to (random number from lowGuess to highGuess)
		-- ask the user to check my guess
		set guessResult to button returned of (display dialog "I guess " & computersGuess & "!" & return & "What do you think?" buttons {"Lower", "Correct", "Higher"})
		if guessResult = "Lower" then
			-- the number is less than the guess, switch the upper limit to the guess
			set highGuess to computersGuess
		else if guessResult = "Higher" then
			-- the number is greater than the guess, switch the lower limit to the guess
			set lowGuess to computersGuess
		else if guessResult = "Correct" then
			-- the computer guessed the number, beep and exit
			beep
			exit repeat
		end if
	end repeat
end run
