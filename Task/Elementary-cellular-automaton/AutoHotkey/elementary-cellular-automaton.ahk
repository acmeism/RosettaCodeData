state := StrSplit("0000000001000000000")
rule := 90
output := "Rule: " rule
Loop, 10 {
	output .= "`n" A_Index "`t" PrintState(state)
	state := NextState(state, rule)
}
Gui, Font,, Courier New
Gui, Add, Text,, % output
Gui, Show
return

GuiClose:
ExitApp

; Returns the next state based on the current state and rule.
NextState(state, rule) {
	r := ByteDigits(rule)
	result := {}
	for i, val in state {
		if (i = 1)			; The leftmost cell
			result.Insert(r[state[state.MaxIndex()] state.1 state.2])
		else if (i = state.MaxIndex())	; The rightmost cell
			result.Insert(r[state[i-1] val state.1])
		else				; All cells between leftmost and rightmost
			result.Insert(r[state[i - 1] val state[i + 1]])
	}
	return result
}

; Returns an array with each three digit sequence as a key corresponding to a value
; of true or false depending on the rule.
ByteDigits(rule) {
	res := {}
	for i, val in ["000", "001", "010", "011", "100", "101", "110", "111"] {
		res[val] := Mod(rule, 2)
		rule >>= 1
	}
	return res
}

; Converts 0 and 1 to . and # respectively and returns a string representing the state
PrintState(state) {
	for i, val in state
		result .= val = 1 ? "#" : "."
	return result
}
