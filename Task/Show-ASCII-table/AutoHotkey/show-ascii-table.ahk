AutoTrim,Off ;Allows for whitespace at end of variable to separate converted characters

MessageText := ;The text to display in the final message box.
CurrentASCII := 32 ;Current ASCII number to convert and add to MessageText
ConvertedCharacter := ;Stores the currently converted ASCII code
RowLength := 0 ;Keeps track of the number of converted ASCII numbers in each row

Loop { ;Loops through each ASCII character and makes a list in MessageText
	if CurrentASCII > 127 ;When the current ASCII number goes over 127, terminate the loop
		Break
	if (RowLength = 6) { ;Checks if the row is 6 converted characters long, and if so, inserts a line break (`n)
		MessageText = %MessageText%`n
		RowLength := 0
	}
	if (CurrentASCII = 32) {
		ConvertedCharacter = SPC
	} else {
		if (CurrentASCII = 127) {
			ConvertedCharacter = DEL
		}
		else {
			ConvertedCharacter := Chr(CurrentASCII) ;Converts CurrentASCII number using Chr() and stores it in ConvertedCharacter
		}
	}
	MessageText = %MessageText%%CurrentASCII%: %ConvertedCharacter%`t ;Adds converted ASCII to end of MessageText
	CurrentASCII := CurrentASCII + 1
	RowLength := RowLength + 1
}
MsgBox, % MessageText ;Displays a message box with the ASCII conversion table, from the MessageText variable
return
