repeat
	set pstart to some item of {true, false}
	if pstart then
		display alert "You go first!"
		set score to 0
	else
		display alert "The computer goes first!"
		log "The computer chose 1"
		log "The score is now 1"
		set score to 1
	end if
	repeat
		repeat
			set input to display alert "Choose a number:" buttons {1, 2, 3}
			set pmove to button returned of input
			set score to score + pmove
			if score > 21 then
				display alert "You can't go above 21! Try again."
				set score to score - pmove
			else
				exit repeat
			end if
		end repeat
		log "You chose " & pmove
		log "The score is now " & score
		if score = 21 then
			log "You win!"
			exit repeat
		else if score mod 4 is not 1 then
			set cmove to (5 - (score mod 4)) mod 4
		else
			set cmove to random number from 1 to 3
		end if
		set score to score + cmove
		log "The computer chose " & cmove
		log "The score is now " & score
		if score = 21 then
			log "Too bad! The computer wins."
			exit repeat
		end if
	end repeat
	set again to display alert "Play again?" buttons {"Yes", "No"}
	if button returned of again = "No" then exit repeat
end repeat
