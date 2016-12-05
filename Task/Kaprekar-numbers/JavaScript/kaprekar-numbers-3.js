function kaprekar( s, e, bs, pbs ) {
	bs = bs || 10; pbs = pbs || 10
	const toString = n => n.toString(pbs).toUpperCase()
	document.write('start:',toString(s), ' end:',toString(e), ' base:',bs, ' printBase:',pbs, '<br>' )
	for (var k=0, n=s; n<=e; n+=1) if (isKaprekar(n, bs)) k+=1, document.write(toString(n), ' ')
	document.write('<br>found ', k, ' numbers<br><br>')
}

kaprekar( 1, 99 )
kaprekar( 1, 255, 16)
kaprekar( 1, 255, 16, 16)
kaprekar( 1, 288, 17, 17)
