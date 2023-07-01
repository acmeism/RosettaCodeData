function isKaprekar( n, bs ) {
	if ( n < 1 ) return false
	if ( n == 1 ) return true
	bs = bs || 10
	var s = (n * n).toString(bs)
	for (var i=1, e=s.length; i<e; i+=1) {
		var a = parseInt(s.substr(0, i), bs)
		var b = parseInt(s.substr(i), bs)
		if (b && a + b == n) return true
	}
	return false
}
