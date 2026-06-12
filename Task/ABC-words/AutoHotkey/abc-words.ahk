FileRead, unixdict, unixdict.txt
Loop, Parse, unixdict, `n
	if ABCWord(A_LoopField)
	{
		count++
		text .= count ": " A_LoopField "`n"
	}
Msgbox, %text%

ABCWord(Word) {
	if InStr(Word, "a")
		if InStr(Word, "b") > InStr(Word, "a")
			if InStr(Word, "c") > InStr(Word, "b")
				return true
			else
				return false
		else
			return false
	else
		return false
}
