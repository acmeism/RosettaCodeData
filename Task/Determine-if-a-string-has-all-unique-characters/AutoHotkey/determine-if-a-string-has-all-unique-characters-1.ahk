unique_characters(str){
	arr := [], res := ""
	for i, v in StrSplit(str)
		arr[v] := arr[v] ? arr[v] "," i : i
	for i, v in Arr
		if InStr(v, ",")
			res .= v "|" i " @ " v "`tHex = " format("{1:X}", Asc(i)) "`n"
	Sort, res, N
	res := RegExReplace(res, "`am)^[\d,]+\|")
	res := StrSplit(res, "`n").1
	return """" str """`tlength = " StrLen(str) "`n" (res ? "Duplicates Found:`n" res : "Unique Characters")
}
