set scores to {0, 0}
set tmpscores to {0, 0}
set t to 1
repeat
	set input to display alert "Player " & t & "'s turn." buttons {"Hold", "Roll", "Quit"}
	if button returned of input = "Hold" then
		set item t of scores to item t of tmpscores
		log "Player " & t & " holds with " & (item t of scores) & " points."
		set t to 3 - t
	else if button returned of input = "Roll" then
		set dieroll to random number from 1 to 6
		log "Player " & t & " rolled a " & dieroll & "!"
		if dieroll = 1 then
			log "Player " & t & " is bust!"
			log "Player " & t & " has " & (item t of scores) & " points."
			set t to 3 - t
		else
			set item t of tmpscores to (item t of tmpscores) + dieroll
			log "Player " & t & " has " & (item t of tmpscores) & " points."
			if (item t of tmpscores) > 100 then
				log "Player " & t & " wins!"
				exit repeat
			end if
		end if
	else if button returned of input = "Quit" then
		exit repeat
	end if
end repeat
