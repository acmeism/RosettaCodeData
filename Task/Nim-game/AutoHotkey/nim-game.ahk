Play:
tokens := 12
while tokens {
	while !(D>0 && D<4)
		InputBox, D, Nim Game, % "Tokens Remaining = " tokens
		. "`nHow many tokens would you like to take?"
		. "`nChoose 1, 2 or 3"
	tokens -= D
	MsgBox % "Computer Takes " 4-D
	tokens -= 4-d, d:=0
}
MsgBox, 262212,,Computer Always Wins!`nWould you like to play again?
IfMsgBox, Yes
	gosub Play
else
	ExitApp
return
