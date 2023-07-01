Long_year(y) {
	A := Mod(y + floor(y/4) - floor(y/100) + floor(y/400), 7)
	y--, B := Mod(y + floor(y/4) - floor(y/100) + floor(y/400), 7)
	return A=4 || B=3
}
