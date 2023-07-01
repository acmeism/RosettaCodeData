LetterFreq(Var) {
	Loop, 26
	{
		StrReplace(Var, Chr(96+A_Index), , Count)
		if Count
			out .= Chr(96+A_Index) ": " Count "`n"
	}
	return out
}

var := "The dog jumped over the lazy fox"
var2 := "foo bar"
Msgbox, % LetterFreq(var)
Msgbox, % LetterFreq(var2)
