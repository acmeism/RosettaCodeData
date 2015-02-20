for k, v in [[0, 25], [250, 265], [1000, 1025]] {
	while v[1] <= v[2] {
		Out .= Ordinal(v[1]) " "
		v[1]++
	}
	Out .= "`n"
}
MsgBox, % Out

Ordinal(n) {
	s2 := Mod(n, 100)
	if (s2 > 10 && s2 < 14)
		return n "th"
	s1 := Mod(n, 10)
	return n (s1 = 1 ? "st" : s1 = 2 ? "nd" : s1 = 3 ? "rd" : "th")
}
