NauticalBell(hh, mm){
	Hr := 0, min := 30, Bells := [], pattern := []
	Loop 8											; genrate 8 patterns
	{
		num := A_Index	, code := ""
		while (num/2 >=1)
			code .= "**  ", num := num-2
		code .= mod(A_Index, 2) ? "*" : ""
		pattern[A_Index] := code
	}
	loop, 48										; 24 hours * 2 for every half an hour
	{
		numBells := !mod(A_Index, 8) ? 8 : mod(A_Index, 8)	, min := 30
		if !Mod(A_Index, 2)
			hr++ , min := 00
		Bells[SubStr("0" hr, -1) ":" min] := numBells
	}
	Bells[00 ":" 00] := Bells[24 ":" 00]	, numBells := Bells[hh ":" mm]
	return {"bells": numBells, "pattern": Pattern[numBells]}
}
