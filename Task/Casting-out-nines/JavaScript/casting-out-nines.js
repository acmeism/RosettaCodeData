function main( s, e, bs, pbs ) {
	bs = bs || 10; pbs = pbs || 10
	document.write('start:',toString(s), ' end:',toString(e), ' base:',bs, ' printBase:',pbs )
	document.write('<br>castOutNine: '); castOutNine()
	document.write('<br>kaprekar: '); kaprekar()
	document.write('<br><br>')
	function castOutNine() {
		for (var n=s, k=0, bsm1=bs-1; n<=e; n+=1) if (n%bsm1 == (n*n)%bsm1) k+=1, document.write(toString(n), ' ')
		document.write('<br>trying ', k, ' numbers instead of ', n=e-s+1, ' numbers saves ',  (100-k/n*100).toFixed(3), '%')
	}
	function kaprekar() {
		for (var n=s; n<=e; n+=1) if (isKaprekar(n)) document.write(toString(n), ' ')
		function isKaprekar( n ) {
			if ( n < 1 ) return false
			if ( n == 1 ) return true
			var s = (n * n).toString(bs)
			for (var i=1, e=s.length; i<e; i+=1) {
				var a = parseInt(s.substr(0, i), bs)
				var b = parseInt(s.substr(i), bs)
				if (b && a + b == n) return true
		    }
		    return false
		}
	}
	function toString( n ) {
		return n.toString(pbs).toUpperCase()
	}
}
main(1, 10*10-1)
main(1, 16*16-1, 16)
main(1, 17*17-1, 17)
main(parseInt('10',17), parseInt('gg',17), 17, 17)
