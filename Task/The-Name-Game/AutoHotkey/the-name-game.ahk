for i, x in StrSplit("Gary,Earl,Billy,Felix,Mary", ","){
	BFM := false
	if (SubStr(x, 1, 1) ~= "i)^[AEIOU]")	; Vowel
		y := x
	else if (SubStr(x, 1, 1) ~= "i)^[BFM]")	; BFM
		y := SubStr(x,2), BFM := true
	else
		y := SubStr(x,2)
	StringLower, y, y
	output := X ", " X ", bo-"	(SubStr(x,1,1)="b"&&BFM ? "" : "b") Y
	. "`nBanana-fana fo-"		(SubStr(x,1,1)="f"&&BFM ? "" : "f") Y
	. "`nFee-fi-mo-"		(SubStr(x,1,1)="m"&&BFM ? "" : "m") Y
	. "`n" X "!"
	result .= output "`n`n"
}
MsgBox, 262144, ,% result
