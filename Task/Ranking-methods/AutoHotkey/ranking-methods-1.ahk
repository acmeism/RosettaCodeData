Rank(data, opt:=1){ ; opt = 1 Standard (default), 2 Modified, 3 Dense, 4 Ordinal, 5 Fractional
	for index, val in StrSplit(data, "`n", "`r") {
		RegExMatch(val, "^(\d+)\s+(.*)", Match)
		if !(Match1=prev)
			n := index
		prev := Match1
		Res1 .= n "`t" Match "`n"
		Res4 .= index "`t" Match "`n"
		Temp .= n ":" index " " Match "`n"
	}
	n:=0
	while pos := RegExMatch(Temp, "`asm)^(\d+).*?\R(?!\1)|.+", Match, pos?pos+StrLen(Match):1) {
		n += StrSplit(Trim(Match, "`r`n"), "`n", "`r").MaxIndex()
		Res2 .= RegExReplace(Match, "`am)^\d+:\d+", n "`t")
		Res3 .= RegExReplace(Match, "`am)^\d+:\d+", A_Index "`t")
		R := 0
		for index, val in StrSplit(Match, "`n", "`r")
			R += StrSplit(val, ":").2
		Res5 .= RegExReplace(Match, "`am)^\d+:\d+", RegExReplace(R / StrSplit(Trim(Match, "`r`n"), "`n", "`r").MaxIndex(), "\.?0+$") "`t")
	}
	return Res%opt%
}
