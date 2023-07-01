WCBT(oTwr){
	topL := Max(oTwr*), l := num := 0, barCh := lbarCh := "", oLvl := []
	while (++l <= topL)
		for t, h in oTwr
			oLvl[l,t] := h ? "██" : "≈≈" , oTwr[t] := oTwr[t]>0 ? oTwr[t]-1 : 0
	for l, obj in oLvl{
		while (oLvl[l, A_Index] = "≈≈")
			oLvl[l, A_Index] := "  "
		while (oLvl[l, obj.Count() +1 - A_Index] = "≈≈")
			oLvl[l, obj.Count() +1 - A_Index] := "  "
		for t, v in obj
			lbarCh .= StrReplace(v, "≈≈", "≈≈", n), num += n
		barCh := lbarCh "`n" barCh, lbarCh := ""
	}
	return [num, barCh]
}
