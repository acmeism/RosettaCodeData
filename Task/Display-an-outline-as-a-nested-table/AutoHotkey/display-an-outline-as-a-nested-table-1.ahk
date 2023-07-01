outline2table(db, Delim:= "`t"){
	oNum:=[], oMID:=[], oNod := [], oKid := [], oPnt := [], oMbr := [], oLvl := []
	oCrl := ["#ffffe6;", "#ffebd2;", "#f0fff0;", "#e6ffff;", "#ffeeff;"]
	col := 0, out := "", anc := ""
	
	; create numerical index for each line
	for i, line in StrSplit(db, "`n", "`r")
	{
		RegExMatch(line, "^(\t*)(.*)$", m)
		out .= m1 . i "`n"
		oNum[i] := m2
	}
	db := Trim(out, "`n")

	; create list of members, parents, kids and their ancestors
	for i, mbr in StrSplit(db, "`n", "`r")
	{
		lvl := 1
		While (SubStr(mbr, 1, 1) = Delim)
			lvl++,	mbr := SubStr(mbr, 2)
		
		if (pLvl >= lvl) && pMbr
			col++
			, oMbr[pLvl, pMbr] .=  "col:" col ",anc:" anc
			, oKid[pLvl, pMbr] .=  "col:" col ",anc:" anc
		
		if (pLvl > lvl) && pMbr
			loop % pLvl - lvl
				anc := RegExReplace(anc, "\d+_?$")
		
		if (pLvl < lvl) && pMbr
			anc .= pMbr "_"
			, oMbr[pLvl, pMbr] .= "col:" col+1 ",anc:" anc
			, oPnt[pLvl, pMbr] .= "col:" col+1 ",anc:" anc
		
		pLvl	:= lvl
		pMbr	:= mbr
		;~ oMID[lvl] := TV_Add(mbr, oMID[lvl-1], "Expand")
	}
	; last one on the list
	col++
	oMbr[pLvl, pMbr] .= "col:" col ",anc:" anc
	oKid[pLvl, pMbr] .= "col:" col ",anc:" anc

	; setup node color
	clr := 1
	for lvl, obj in oMbr
		for node, str in obj
			if (lvl <= 2)
				oNod[node, "clr"] := clr++
			else
				oNod[node, "clr"] := oNod[StrSplit(str, "_").2, "clr"]
		
	; setup node level/column/width
	for lvl, obj in oKid
		for node, str in obj
		{
			x := StrSplit(str, ",")
			col := StrReplace(x.1, "col:")
			anc := Trim(StrReplace(x.2, "anc:"), "_")
			for j, a in StrSplit(anc, "_")
				oNod[a, "wid"] := (oNod[a, "wid"]?oNod[a, "wid"]:0) + 1
				
			oNod[node, "lvl"] := lvl
			oNod[node, "col"] := col
			oNod[node, "wid"] := 1
		}
		
	for lvl, obj in oPnt
		for node, str in obj
		{
			x := StrSplit(str, ",")
			col := StrReplace(x.1, "col:")
			anc := Trim(StrReplace(x.2, "anc:"), "_")
			oNod[node, "lvl"] := lvl
			oNod[node, "col"] := col
		}
	
	; setup members by level
	for node, obj in oNod
		oLvl[obj["lvl"], node] := 1
	
	maxW := 0
	for node in oLvl[1]
		maxW += oNod[node, "wid"]
		
	; setup HTML
	html := "<table class=""wikitable"" style=""text-align: center;"">`n"
	for lvl, obj in oLvl
	{
		pCol := 1
		html .= "<tr>`n"
		for node, bool in obj
		{
			while (oNod[node, "col"] <> pCol)
				pCol++, html .= "`t<td style=""background: #F9F9F9;""></td>`n"
			pCol += oNod[node, "wid"]
			if !cNum := Mod(oNod[node, "clr"], 5)
				cNum := 5
			html .= "`t<td style=""background: " oCrl[cNum] """ colspan=""" oNod[node, "wid"] """>" oNum[node] "</td>`n"
		}
		while (pCOl <= maxW)
			pCol++, html .= "`t<td style=""background: #F9F9F9;""></td>`n"
		html .= "</tr>`n"
	}
	html .= "</table>"
	
	; setup wikitable
	wTable := "{| class=""wikitable"" style=""text-align: center;""`n"
	for lvl, obj in oLvl
	{
		pCol := 1
		wTable .= "|-`n"
		for node, bool in obj
		{
			while (oNod[node, "col"] <> pCol)
				pCol++, wTable .= "|  | `n"
			pCol += oNod[node, "wid"]
			if !cNum := Mod(oNod[node, "clr"], 5)
				cNum := 5
			wTable .= "| style=""background: " oCrl[cNum] """ colspan=""" oNod[node, "wid"] " |" oNum[node] "`n"
		}
		while (pCOl <= maxW)
			pCol++, wTable .= "|  | `n"
		
	}
	wTable .= "|}`n"
	return [html, wTable]
}
