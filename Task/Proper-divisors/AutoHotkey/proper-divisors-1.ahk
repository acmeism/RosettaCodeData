proper_divisors(n) {
	Array := []
	if n = 1
		return Array
	Array[1] := true
	x := Floor(Sqrt(n))
	loop, % x+1
		if !Mod(n, i:=A_Index+1) && (floor(n/i) < n)
			Array[floor(n/i)] := true
	Loop % n/x
		if !Mod(n, i:=A_Index+1) && (i < n)
			Array[i] := true
	return Array
}
