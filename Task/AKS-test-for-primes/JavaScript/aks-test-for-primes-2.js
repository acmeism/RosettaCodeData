function pascal(n) {
	var cs = []; if (n) while (n--) coef(); return coef
	function coef() {
		if (cs.length === 0) return cs = [1];
		for (var t=[1,1], i=cs.length-1; i; i-=1) t.splice( 1, 0, cs[i-1]+cs[i] ); return cs = t
	}
}

function show(cs) {
	for (var s='', sgn=true, i=0, deg=cs.length-1; i<=deg; sgn=!sgn, i+=1) {
		s += ' ' + (sgn ? '+' : '-') + cs[i] + (e => e==0 ? '' : e==1 ? 'x' : 'x<sup>' + e + '</sup>')(deg-i)
	}
	return '(x-1)<sup>' + deg + '</sup> =' + s;
}

function isPrime(cs) {
	var deg=cs.length-1; return cs.slice(1, deg).every( function(c) { return c % deg === 0 } )
}

var coef=pascal(); for (var i=0; i<=7; i+=1) document.write(show(coef()), '<br>')

document.write('<br>Primes: ');
for (var coef=pascal(2), n=2; n<=50; n+=1) if (isPrime(coef())) document.write(' ', n)
