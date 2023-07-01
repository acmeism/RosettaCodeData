define gcd(a,b) => {
	while(#b != 0) => {
		local(t = #b)
		#b = #a % #b
		#a = #t
	}
	return #a
}
define lcm(m,n) => {
	 #m == 0 || #n == 0 ? return 0
	 local(r = (#m * #n) / decimal(gcd(#m, #n)))
	 return integer(#r)->abs
}

lcm(-6, 14)
lcm(2, 0)
lcm(12, 18)
lcm(12, 22)
lcm(7, 31)
