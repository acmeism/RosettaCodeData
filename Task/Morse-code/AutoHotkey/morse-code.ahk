TestString := "Hello World! abcdefg @\;"			;Create a string to be sent with multiple caps and some punctuation
MorseBeep(teststring)					;Beeps our string after conversion
return										;End Auto-Execute Section


MorseBeep(passedString)
{
	StringLower, passedString, passedString			;Convert to lowercase for simpler checking
	Loop, Parse, passedString					;This loop stores each character in A_loopField one by one using the more compact form of "if else", by var := x>y ? val1 : val2 which stores val1 in var if x > y, otherwise it stores val2, this can be used together to make a single line of if else
		morse .= A_LoopField = " " ?  "     " : A_LoopField = "a" ? ".- " : A_LoopField = "b" ? "-... " : A_LoopField = "c" ? "-.-. " : A_LoopField = "d" ? "-.. " : A_LoopField = "e" ? ". " : A_LoopField = "f" ? "..-. " : A_LoopField = "g" ? "--. " : A_LoopField = "h" ? ".... " : A_LoopField = "i" ? ".. " : A_LoopField = "j" ? ".--- " : A_LoopField = "k" ? "-.- " : A_LoopField = "l" ? ".-.. " : A_LoopField = "m" ? "-- " : A_LoopField = "n" ? "-. " : A_LoopField = "o" ? "--- " : A_LoopField = "p" ? ".--. " : A_LoopField = "q" ? "--.- " : A_LoopField = "r" ? ".-. " : A_LoopField = "s" ? "... " : A_LoopField = "t" ? "- " : A_LoopField = "u" ? "..- " : A_LoopField = "v" ? "...- " : A_LoopField = "w" ? ".-- " : A_LoopField = "x" ? "-..- " : A_LoopField = "y" ? "-.-- " : A_LoopField = "z" ? "--.. " : A_LoopField = "!" ? "---. " : A_LoopField = "\" ? ".-..-. " : A_LoopField = "$" ? "...-..- " : A_LoopField = "'" ? ".----. " : A_LoopField = "(" ? "-.--. " : A_LoopField = ")" ? "-.--.- " : A_LoopField = "+" ? ".-.-. " : A_LoopField = "," ? "--..-- " : A_LoopField = "-" ? "-....- " : A_LoopField = "." ? ".-.-.- " : A_LoopField = "/" ? "-..-. " : A_LoopField = "0" ? "----- " : A_LoopField = "1" ? ".---- " : A_LoopField = "2" ? "..--- " : A_LoopField = "3" ? "...-- " : A_LoopField = "4" ? "....- " : A_LoopField = "5" ? "..... " : A_LoopField = "6" ? "-.... " : A_LoopField = "7" ? "--... " : A_LoopField = "8" ? "---.. " : A_LoopField = "9" ? "----. " : A_LoopField = ":" ? "---... " : A_LoopField = ";" ? "-.-.-. " : A_LoopField = "=" ? "-...- " : A_LoopField = "?" ? "..--.. " : A_LoopField = "@" ? ".--.-. " : A_LoopField = "[" ? "-.--. " : A_LoopField = "]" ? "-.--.- " : A_LoopField = "_" ? "..--.- " : "ERROR" ; ---End conversion loop---
	Loop, Parse, morse
	{
		morsebeep := 120
		if (A_LoopField = ".")
			SoundBeep, 10*morsebeep, morsebeep		;Format: SoundBeep, frequency, duration
		If (A_LoopField = "-")
			SoundBeep, 10*morsebeep, 3*morsebeep	;Duration can be an expression
		If (A_LoopField = " ")
			Sleep, morsebeep					;Above, each character is followed by a space, and literal
	}									;Spaces are extended. Sleep pauses the script
	return morse								;Returns the text in morse code
} ;                                                         ---End Function Morse---
