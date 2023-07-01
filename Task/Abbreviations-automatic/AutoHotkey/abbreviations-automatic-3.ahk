Loop, Read, days-of-the-week.txt  ; input text in current dir
	{
		if (A_Index > 10)   ; number of lines to output
			break
		Loop, Parse, A_LoopReadLine, %A_Space%  ; create an array of the days
			word%A_Index% := A_LoopField        ; word1=sunday, word2=monday ...
		loop
			{
				x := A_Index   ;save the last loop index
				abrev := ""
				loop 7
					abrev .= SubStr(word%A_Index%, 1, x) . ","   ; x = length to test (1,2,3...)
				sort, abrev, U D,                                ; sort unique (errorlevel = duplicates)
			}
		until ErrorLevel = 0   ;stay with last loop index (length)
		minimalAb .= x . " " . A_LoopReadLine . " (" . abrev . ")`n"
	}
msgbox % minimalAb
ExitApp
