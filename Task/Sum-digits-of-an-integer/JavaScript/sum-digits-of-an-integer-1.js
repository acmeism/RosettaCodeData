function sumDigits(n) {
	n += ''
	for (var s=0, i=0, e=n.length; i<e; i+=1) s+=parseInt(n.charAt(i),36)
	return s
}
for (var n of [1, 12345, 0xfe, 'fe', 'f0e', '999ABCXYZ']) document.write(n, ' sum to ', sumDigits(n), '<br>')
