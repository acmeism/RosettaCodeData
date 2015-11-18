Permutations_By_Swapping(str, list:=""){
	ch := SubStr(str, 1, 1)								; get left-most charachter of str
	for i, line in StrSplit(list, "`n")					; for each line in list
		loop % StrLen(line) + 1							; loop each possible position
			Newlist .= RegExReplace(line, mod(i,2) ? "(?=.{" A_Index-1 "}$)" : "^.{" A_Index-1 "}\K", ch) "`n"
	list := Newlist ? Trim(Newlist, "`n") : ch			; recreate list
	if !str := SubStr(str, 2)							; remove charachter from left hand side
		return list										; done if str is empty
	return Permutations_By_Swapping(str, list)			; else recurse
}
