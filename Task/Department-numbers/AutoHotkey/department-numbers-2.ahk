elements := "1234567", n := 3
for k, v in perm(elements, n)
	if (SubStr(v, 1, 1) + SubStr(v, 2, 1) + SubStr(v, 3, 1) = 12) && (SubStr(v, 1, 1) / 2 = Floor(SubStr(v, 1, 1)/2))
		res4 .= v "`n"

MsgBox, 262144, , % res4
return
