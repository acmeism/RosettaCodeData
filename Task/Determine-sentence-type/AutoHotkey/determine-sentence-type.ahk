Sentence := "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it"
Msgbox, % SentenceType(Sentence)

SentenceType(Sentence) {
	Sentence := Trim(Sentence)
	Loop, Parse, Sentence, .?!
	{
		N := (!E && !Q && !S)
		, S := (InStr(SubStr(Sentence, InStr(Sentence, A_LoopField)+StrLen(A_LoopField), 3), "."))
		, Q := (InStr(SubStr(Sentence, InStr(Sentence, A_LoopField)+StrLen(A_LoopField), 3), "?"))
		, E := (InStr(SubStr(Sentence, InStr(Sentence, A_LoopField)+StrLen(A_LoopField), 3), "!"))
		, type .= (E) ? ("E|") : ((Q) ? ("Q|") : ((S) ? ("S|") : "N|"))
		, D := SubStr(Sentence, InStr(Sentence, A_LoopField)+StrLen(A_LoopField), 3)
	}
	return (D = SubStr(Sentence, 1, 3)) ? RTrim(RTrim(type, "|"), "N|") : RTrim(type, "|")
}
