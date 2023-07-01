randomize
MyNum=Int(rnd*10)+1
Do
	x=x+1
	YourGuess=InputBox("Enter A number from 1 to 10")
	If not Isnumeric(YourGuess) then
		msgbox YourGuess &" is not numeric. Try again."
	ElseIf CInt(YourGuess)>10 or CInt(YourGuess)<1 then
		msgbox YourGuess &" is not between 1 and 10. Try Again."
	ElseIf CInt(YourGuess)=CInt(MyNum) then
		MsgBox "Well Guessed!"
		wscript.quit
	ElseIf Cint(YourGuess)<>CInt(Mynum) then
		MsgBox "Nope. Try again."
	end If

	if x > 20 then
		msgbox "I take pity on you"
		wscript.quit
	end if
loop
