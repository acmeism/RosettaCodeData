on inputloop()
	repeat
        set input to display dialog "Enter a sequence of 3 coin tosses (H or T)" default answer ""
		set seq to text returned of input
		set cflag to true
		if length of seq is 3 then
			repeat with c in characters of seq
				if c is not in {"H", "T"} then
					display alert "That's not a valid entry. Try again!"
					set cflag to false
					exit repeat
				end if
			end repeat
			if cflag then exit repeat
		else
			display alert "That's not a valid entry. Try again!"
		end if
	end repeat
	return characters of seq
end inputloop

repeat
	set pstart to some item of {true, false}
	if pstart then
		display alert "You go first!"
		set pseq to inputloop()
		log "You chose: " & pseq
		if item 2 of pseq is "H" then
			set cfirst to "T"
		else
			set cfirst to "H"
		end if
		set cseq to {cfirst} & (items 1 thru 2 of pseq)
		log "The computer chose: " & cseq
	else
		display alert "The computer goes first!"
		set cseq to {}
		repeat 3 times
			set cseq to cseq & some item of {"H", "T"}
		end repeat
		log "The computer chose: " & cseq
		repeat
			set pseq to inputloop()
			if pseq = cseq then
				display alert "You can't choose the same sequence as the computer! Try again."
			else
				exit repeat
			end if
		end repeat
		log "You chose: " & pseq
	end if
	set throws to {}
	log "Throwing:"
	repeat
		set throws to throws & some item of {"H", "T"}
		log throws as text
		if throws contains pseq then
			log "You win!"
			exit repeat
		else if throws contains cseq then
			log "Too bad! The computer wins."
			exit repeat
		end if
	end repeat
	set again to display alert "Play again?" buttons {"Yes", "No"}
	if button returned of again = "No" then exit repeat
end repeat
