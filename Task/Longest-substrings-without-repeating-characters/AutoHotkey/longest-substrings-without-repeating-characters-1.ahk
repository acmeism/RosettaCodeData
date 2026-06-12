LSWRC(str){
	found := [], result := [], maxL := 0
	if (StrLen(str) = 1)
		result[str] := true
	else while (StrLen(str) >= 2){
		s := str
		while StrLen(s) >= maxL{
			if !(s ~= "(.).*\1"){
				found[s] := true
				maxL := maxL < StrLen(s) ? StrLen(s) : maxL
				break
			}
			s := SubStr(s, 1, StrLen(s)-1)			; trim last chr
		}
		str := SubStr(str, 2)						; trim 1st chr and try again
	}
	maxL := 0
	for str in found
		maxL := maxL < StrLen(str) ? StrLen(str) : maxL
	for str in found
		if (StrLen(str) = maxL)
			result[str] := true
	return result
}
