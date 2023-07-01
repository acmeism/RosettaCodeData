i:= 42, n:= 1, result := ""
while (n<43){
	if isPrime(i)
		result .= n ":`t" RegExReplace(i, "\B(?=(\d{3})+$)", ",") "`n", i*=2, n++
	else
		i++
}
MsgBox, 262208, , % result
return

isPrime(num){
	if !Mod(num, 2) || !Mod(num, 3)
		return false
	lim := Sqrt(num),	i := 5
	while (i<lim){
		if !Mod(num, i)
			return false
		i+=2
	}
	return true
}
