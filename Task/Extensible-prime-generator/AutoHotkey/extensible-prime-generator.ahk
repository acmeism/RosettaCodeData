SetBatchLines, -1
p := 1	;p functions as the counter
Loop, 10000 {
	p := NextPrime(p)
	if (A_Index < 21)
		a .= p ", "
	if (p < 151 && p > 99)
		b .= p ", "
	if (p < 8001 && p > 7699)
		c++
}
MsgBox, % "First twenty primes: " RTrim(a, ", ")
	. "`nPrimes between 100 and 150: " RTrim(b, ", ")
	. "`nNumber of primes between 7,700 and 8,000: " RTrim(c, ", ")
	. "`nThe 10,000th prime: " p

NextPrime(n) {
	Loop
		if (IsPrime(++n))
			return n
}

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
