on pickNumber()
	set theNumber to ""
	repeat 4 times
		set theDigit to (random number from 1 to 9) as string
		repeat while (offset of theDigit in theNumber) > 0
			set theDigit to (random number from 1 to 9) as string
		end repeat
		set theNumber to theNumber & theDigit
	end repeat
end pickNumber

to bulls of theGuess given key:theKey
	set bullCount to 0
	repeat with theIndex from 1 to 4
		if text theIndex of theGuess = text theIndex of theKey then
			set bullCount to bullCount + 1
		end if
	end repeat
	return bullCount
end bulls

to cows of theGuess given key:theKey, bulls:bullCount
	set cowCount to -bullCount
	repeat with theIndex from 1 to 4
		if (offset of (text theIndex of theKey) in theGuess) > 0 then
			set cowCount to cowCount + 1
		end if
	end repeat
	
	return cowCount
end cows

to score of theGuess given key:theKey
	set bullCount to bulls of theGuess given key:theKey
	set cowCount to cows of theGuess given key:theKey, bulls:bullCount
	return {bulls:bullCount, cows:cowCount}
end score

on run
	set theNumber to pickNumber()
	set pastGuesses to {}
	repeat
		set theMessage to ""
		repeat with aGuess in pastGuesses
			set {theGuess, theResult} to aGuess
			set theMessage to theMessage & theGuess & ":" & bulls of theResult & "B, " & cows of theResult & "C" & linefeed
		end repeat
		set theMessage to theMessage & linefeed & "Enter guess:"
		set theGuess to text returned of (display dialog theMessage with title "Bulls and Cows" default answer "")
		set theScore to score of theGuess given key:theNumber
		if bulls of theScore is 4 then
			display dialog "Correct!  Found the secret in " & ((length of pastGuesses) + 1) & " guesses!"
			exit repeat
		else
			set end of pastGuesses to {theGuess, theScore}
		end if
	end repeat
end run
