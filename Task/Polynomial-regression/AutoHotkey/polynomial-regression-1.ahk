regression(xa,ya){
	n := xa.Count()
	xm := ym := x2m := x3m := x4m := xym := x2ym := 0
	
	loop % n {
		i := A_Index
		xm := xm + xa[i]
		ym := ym + ya[i]
		x2m := x2m + xa[i] * xa[i]
		x3m := x3m + xa[i] * xa[i] * xa[i]
		x4m := x4m + xa[i] * xa[i] * xa[i] * xa[i]
		xym := xym + xa[i] * ya[i]
		x2ym := x2ym + xa[i] * xa[i] * ya[i]
	}
	
	xm := xm / n
	ym := ym / n
	x2m := x2m / n
	x3m := x3m / n
	x4m := x4m / n
	xym := xym / n
	x2ym := x2ym / n

	sxx := x2m - xm * xm
	sxy := xym - xm * ym
	sxx2 := x3m - xm * x2m
	sx2x2 := x4m - x2m * x2m
	sx2y := x2ym - x2m * ym

	b := (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
	c := (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
	a := ym - b * xm - c * x2m
	
	result := "Input`tApproximation`nx   y`ty1`n"
	loop % n
		i := A_Index, result .= xa[i] ", " ya[i] "`t" eval(a, b, c, xa[i]) "`n"
	return "y = " c "x^2" " + " b "x + " a "`n`n" result
}
eval(a,b,c,x){
	return a + (b + c*x) * x
}
