var e = '3 4 2 * 1 5 - 2 3 ^ ^ / +'
eval: {
	document.write(e, '<br>')
	var s=[], e=e.split(' ')
	for (var i in e) {
		var t=e[i], n=+t
		if (!t) continue
		if (n == t)
			s.push(n)
		else {
			if ('+-*/^'.indexOf(t) == -1) {
				document.write(t, ': ', s, '<br>', 'Unknown operator!<br>')
				break eval
			}
			if (s.length<2) {
				document.write(t, ': ', s, '<br>', 'Insufficient operands!<br>')
				break eval
			}
			var o2=s.pop(), o1=s.pop()
			switch (t) {
				case '+': s.push(o1+o2); break
				case '-': s.push(o1-o2); break
				case '*': s.push(o1*o2); break
				case '/': s.push(o1/o2); break
				case '^': s.push(Math.pow(o1,o2))
			}
		}
		document.write(t, ': ', s, '<br>')
	}
	if (s.length>1) {
		document.write('Insufficient operators!<br>')
	}
}
