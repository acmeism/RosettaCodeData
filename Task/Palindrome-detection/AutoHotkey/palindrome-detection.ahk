IsPalindrome( Str ){
	StringLower, str, str
	str := (RegexReplace(str,"\W+" ))
	Loop, Parse, Str
		reversedStr := A_LoopField . ReversedStr
	Return ( ReversedStr = Str )
}
