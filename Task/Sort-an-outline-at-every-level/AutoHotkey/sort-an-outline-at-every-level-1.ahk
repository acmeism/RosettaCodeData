Sort_an_outline(data, reverse:=""){
	;-----------------------
	; get Delim, Error Check
	for i, line in StrSplit(data, "`n", "`r")
		if !Delim
			RegExMatch(line, "^\h+", Delim)
		else if RegExMatch(RegExReplace(line, "^(" Delim ")*"), "^\h+")
			return "Error @ " line
	;-----------------------
	; ascending lexical sort
	ancestor:=[], tree:= [], result:=""
	for i, line in StrSplit(data, "`n", "`r"){
		name := StrSplit(line, delim?delim:"`t")
		n := name.count()
		son := name[n]
		if (n>rank) && father
			ancestor.push(father)
		loop % rank-n
			ancestor.pop()
		for i, father in ancestor
			Lineage .= father . delim
		output .= Lineage son "`n"
		rank:=n, father:=son, Lineage:=""
	}
	Sort, output
	for i, line in StrSplit(output, "`n", "`r")
		name := StrSplit(line, delim)
		, result .= indent(name.count()-1, delim) . name[name.count()] "`n"
	if !reverse
		return Trim(result, "`n")
	;-----------------------
	; descending lexical sort
	ancestor:=[], Lineage:="", result:=""
	Sort, output, R
	for i, line in StrSplit(output, "`n", "`r"){
		name := StrSplit(line, delim)
		if !ancestor[Lineage]
			loop % name.count()
				result .= indent(A_Index-1, delim) . name[A_Index] "`n"
		else if (StrSplit(Lineage, ",")[name.count()] <> name[name.count()])
			result .= indent(name.count()-1, delim) . name[name.count()] "`n"
		Lineage := ""
		loop % name.count()-1
			Lineage .= (Lineage ? "," : "") . name[A_Index]
			, ancestor[Lineage] := true
	}
	return result
}
indent(n, delim){
	Loop, % n
		result.=delim
	return result
}
