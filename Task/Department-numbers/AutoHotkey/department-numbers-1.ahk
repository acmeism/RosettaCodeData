perm(elements, n, opt:="", Delim:="", str:="", res:="", j:=0, dup:="") {	
	res := IsObject(res) ? res : [], dup := IsObject(dup) ? dup : []
	if (n > j)
		Loop, parse, elements, % Delim
			res := !(InStr(str, A_LoopField) && !(InStr(opt, "rep"))) ? perm(elements, n, opt, Delim, trim(str Delim A_LoopField, Delim), res, j+1, dup) : res
	else if !(dup[x := perm_sort(str, Delim)] && (InStr(opt, "comb")))
		dup[x] := 1, res.Insert(str)
	return res, j++
}

perm_sort(str, Delim){
	Loop, Parse, str, % Delim
		res .= A_LoopField "`n"
	Sort, res, D`n
	return StrReplace(res, "`n", Delim)
}
