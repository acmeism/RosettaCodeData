str := "what,is,the;meaning,of:life."
loop, parse, str
	if (A_LoopField ~= "[[:punct:]]")
		res .= A_LoopField, toggle:=!toggle
	else
		res := toggle ? RegExReplace(res, ".*[[:punct:]]\K", A_LoopField ) : res A_LoopField
MsgBox % res
