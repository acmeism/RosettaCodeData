function tokenize(s, esc, sep) {
	for (var a=[], t='', i=0, e=s.length; i<e; i+=1) {
		var c = s.charAt(i)
		if (c == esc) t+=s.charAt(++i)
		else if (c != sep) t+=c
		else a.push(t), t=''		
	}
	a.push(t)
	return a
}

var s = 'one^|uno||three^^^^|four^^^|^cuatro|'
document.write(s, '<br>')	
for (var a=tokenize(s,'^','|'), i=0; i<a.length; i+=1) document.write(i, ': ', a[i], '<br>')
