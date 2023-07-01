ISBN13_check_digit(n){
	for i, v in StrSplit(RegExReplace(n, "[^0-9]"))
		sum += !Mod(i, 2) ? v*3 : v
	return n "`t" (Mod(sum, 10) ? "(bad)" : "(good)")
}
