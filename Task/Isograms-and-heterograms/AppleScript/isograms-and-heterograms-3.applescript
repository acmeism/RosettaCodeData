LenOrder(lista) {
	loop,parse,lista,%A_Space%
		if (StrLen(A_LoopField) > MaxLen)
			MaxLen := StrLen(A_LoopField)
	loop % MaxLen-1
		{
			loop,parse,lista,%A_Space%
				if (StrLen(A_LoopField) = MaxLen)
					devolve .= A_LoopField . " "
			MaxLen -= 1
		}
	return devolve		
	}

loop,read,unixdict.txt
{
	encounters := 0, started := false
	loop % StrLen(A_LoopReadLine)
	{
		target := strreplace(A_LoopReadLine,SubStr(A_LoopReadLine,a_index,1),,xt)
		if !started
		{
			started := true
			encounters := xt
		}
		if (xt<>encounters)
			{
				encounters := 0
				continue
			}
		target := A_LoopReadLine
	}
	if (encounters = 1) and (StrLen(target) > 10)
		heterograms .= target " "
	else if (encounters > 1)
		isograms%encounters% .= target " "
}
Loop
{
	if (A_Index = 1)
		continue
	if !isograms%A_Index%
		break
	isograms := LenOrder(isograms%A_Index%) . isograms
}	
msgbox % isograms
msgbox % LenOrder(heterograms)
ExitApp
return

~Esc::
ExitApp
