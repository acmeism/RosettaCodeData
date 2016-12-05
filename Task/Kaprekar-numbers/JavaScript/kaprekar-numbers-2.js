function isKaprekar( n, bs ) {
	if ( n < 1 ) return false
	if ( n == 1 ) return true
	bs = bs || 10
	for (var a=n*n, b=0, s=1; a; s*=bs) {
		b += a%bs*s
		a = Math.floor(a/bs)
		if (b && a + b == n) return true
	}
	return false
}
