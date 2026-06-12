set state to "ready"
repeat while state is not "exit"
	set title to "Machine is " & state & "."
	if state = "ready" then
		set input to display alert title buttons {"Deposit", "Quit"}
		if button returned of input = "Deposit" then
			set state to "waiting"
		else if button returned of input = "Quit" then
			set state to "exit"
		end if
	else if state = "waiting" then
		set input to display alert title buttons {"Select", "Refund"}
		if button returned of input = "Select" then
			set state to "dispensing"
		else if button returned of input = "Refund" then
			set state to "refunding"
		end if
	else if state = "dispensing" then
		display alert title buttons {"Remove product"}
		set state to "ready"
	else if state = "refunding" then
		display alert title
		set state to "ready"
	end if
end repeat
