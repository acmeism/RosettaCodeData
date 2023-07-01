BalancedTernary(n){
	k = 0
	if abs(n)<2
		return n=1?"+":n=0?"0":"-"
	if n<1
		negative := true, n:= -1*n
	while !break {
		d := Mod(n, 3**(k+1)) / 3**k
		d := d=2?-1:d
		n := n - (d * 3**k)
		r := (d=-1?"-":d=1?"+":0) . r
		k++
		if (n = 3**k)
			r := "+" . r	, break := true
	}
	if negative {
		StringReplace, r, r, -,n, all
		StringReplace, r, r, `+,-, all
		StringReplace, r, r, n,+, all
	}
	return r
}
