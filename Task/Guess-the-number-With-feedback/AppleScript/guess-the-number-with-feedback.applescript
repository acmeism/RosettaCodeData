-- defining the range of the number to be guessed
property minLimit : 1
property maxLimit : 100

on run
	-- define the number to be guessed
	set numberToGuess to (random number from minLimit to maxLimit)
	-- prepare a variable to store the user's answer
	set guessedNumber to missing value
	-- prepare a variable for feedback
	set tip to ""
	-- start a loop (will be exited by using "exit repeat" after a correct guess)
	repeat
		-- ask the user for his/her guess, the variable tip contains text after first guess only
		set usersChoice to (text returned of (display dialog "Guess the number between " & minLimit & " and " & maxLimit & " inclusive" & return & tip default answer "" buttons {"Check"} default button "Check"))
		-- try to convert the given answer to an integer and compare it the number to be guessed
		try
			set guessedNumber to usersChoice as integer
			if guessedNumber is greater than maxLimit or guessedNumber is less than minLimit then
				-- the user guessed a number outside the given range
				set tip to "(Tipp: Enter a number between " & minLimit & " and " & maxLimit & ")"
			else if guessedNumber is less than numberToGuess then
				-- the user guessed a number less than the correct number
				set tip to "(Tipp: The number is greater than " & guessedNumber & ")"
			else if guessedNumber is greater than numberToGuess then
				-- the user guessed a number greater than the correct number
				set tip to "(Tipp: The number is less than " & guessedNumber & ")"
			else if guessedNumber is equal to numberToGuess then
				-- the user guessed the correct number and gets informed
				display dialog "Well guessed! The number was " & numberToGuess buttons {"OK"} default button "OK"
				-- exit the loop (quits this application)
				exit repeat
			end if
		on error
			-- something went wrong, remind the user to enter a numeric value
			set tip to "(Tipp: Enter a number between " & minLimit & " and " & maxLimit & ")"
		end try
	end repeat
end run
