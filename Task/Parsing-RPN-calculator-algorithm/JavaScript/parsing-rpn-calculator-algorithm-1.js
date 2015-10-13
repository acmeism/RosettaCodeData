var e = '3 4 2 * 1 5 - 2 3 ^ ^ / +'
var s=[], e=e.split(' ')
for (var i in e) {
	var t=e[i], n=+t
	if (n == t)
		s.push(n)
	else {
		var o2=s.pop(), o1=s.pop()
		switch (t) {
			case '+': s.push(o1+o2); break;
			case '-': s.push(o1-o2); break;
			case '*': s.push(o1*o2); break;
			case '/': s.push(o1/o2); break;
			case '^': s.push(Math.pow(o1,o2)); break;
		}
	}
	document.write(t, ': ', s, '<br>')
}
