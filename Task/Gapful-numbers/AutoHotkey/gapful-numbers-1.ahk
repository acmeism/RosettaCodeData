Gapful_numbers(Min, Qty){
	counter:= 0, output := ""
	while (counter < Qty){
		n := A_Index+Min-1
		d := SubStr(n, 1, 1) * 10 + SubStr(n, 0)
		if (n/d = Floor(n/d))
			output .= ++counter ": " n "`t" n " / " d " = " Format("{:d}", n/d) "`n"
	}
	return output
}
