kprime(n,k) {
	p:=2, f:=0
	while( (f<k) && (p*p<=n) ) {
		while ( 0==mod(n,p) ) {
			n/=p
			f++
		}
		p++
	}
	return f + (n>1) == k
}

k:=1, results:=""
while( k<=5 ) {
	i:=2, c:=0, results:=results "k =" k ":"
	while( c<10 ) {
		if (kprime(i,k)) {
			results:=results " " i
			c++
		}
		i++
	}
	results:=results "`n"
	k++
}

MsgBox % results
