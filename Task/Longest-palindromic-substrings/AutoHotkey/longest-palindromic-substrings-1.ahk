LPS(str){
	found := [], result := [], maxL := 0
	while (StrLen(str) >= 2 && StrLen(str) >= maxL){
		s := str
		loop {
			while (SubStr(s, 1, 1) <> SubStr(s, 0))	; while 1st chr <> last chr
				s := SubStr(s, 1, StrLen(s)-1)		; trim last chr
			if (StrLen(s) < 2 || StrLen(s) < maxL )
				break
			if (s = reverse(s)){
				found.Push(s)
				maxL := maxL < StrLen(s) ? StrLen(s) : maxL
				break
			}
			s := SubStr(s, 1, StrLen(s)-1)			; trim last chr
		}
		str := SubStr(str, 2)						; trim 1st chr and try again
	}
	maxL := 0
	for i, str in found
		maxL := maxL < StrLen(str) ? StrLen(str) : maxL
	for i, str in found
		if (StrLen(str) = maxL)
			result.Push(str)
	return result
}
reverse(s){
	for i, v in StrSplit(s)
		output := v output
	return output
}
