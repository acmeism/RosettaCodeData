on run
	-- define the number to be guessed
	set numberToGuess to (random number from 1 to 10)
	-- prepare a variable to store the user's answer
	set guessedNumber to missing value
	-- start a loop (will be exited by using "exit repeat" after a correct guess)
	repeat
		try
			-- ask the user for his/her guess
			set usersChoice to (text returned of (display dialog "Guess the number between 1 and 10 inclusive" default answer "" buttons {"Check"} default button "Check"))
			-- try to convert the given answer to an integer
			set guessedNumber to usersChoice as integer
		on error
			-- something gone wrong, overwrite user's answer with a non-matching value
			set guessedNumber to missing value
		end try
		-- decide if the user's answer was the right one
		if guessedNumber is equal to numberToGuess then
			-- the user guessed the correct number and gets informed
			display dialog "Well guessed! The number was " & numberToGuess buttons {"OK"} default button "OK"
			-- exit the loop (quits this application)
			exit repeat
		end if
	end repeat
end run
