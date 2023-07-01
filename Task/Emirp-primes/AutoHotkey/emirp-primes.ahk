SetBatchLines, -1
p := 1
Loop, 20 {
	p := NextEmirp(p)
	a .= p " "
}
p := 7700
Loop {
	p := NextEmirp(p)
	if (p > 8000)
		break
	b .= p " "
}
p :=1
Loop, 10000
	p := NextEmirp(p)
MsgBox, % "First twenty emirps: " a
	. "`nEmirps between 7,700 and 8,000: " b
	. "`n10,000th emirp: " p

IsPrime(n) {
	if (n < 2)
		return, 0
	else if (n < 4)
		return, 1
	else if (!Mod(n, 2))
		return, 0
	else if (n < 9)
		return 1
	else if (!Mod(n, 3))
		return, 0
	else {
		r := Floor(Sqrt(n))
		f := 5
		while (f <= r) {
			if (!Mod(n, f))
				return, 0
			if (!Mod(n, (f + 2)))
				return, 0
			f += 6
		}
		return, 1
	}
}

NextEmirp(n) {
	Loop
		if (IsPrime(++n)) {
			rev := Reverse(n)
			if (rev = n)
				continue
			if (IsPrime(rev))
				return n
		}
}

Reverse(s) {
	Loop, Parse, s
		r := A_LoopField r
	return r
}
