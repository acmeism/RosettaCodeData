;This one is a lot more simpler than the rest
BraceExp(string, del:="`n") {
	Loop, Parse, string
		if (A_LoopField = "{")
			break
		else
		substring .= A_LoopField
	substr := SubStr(string, InStr(string, "{")+1, InStr(string, "}")-InStr(string, "{")-1)
	Loop, Parse, substr, `,
		toreturn .= substring . A_LoopField . del
	return toreturn
}

Msgbox, % BraceExp("enable_{video,audio}")
Msgbox, % BraceExp("apple {bush,tree}")
Msgbox, % BraceExp("h{i,ello}")
Msgbox, % BraceExp("rosetta{code,stone}")
