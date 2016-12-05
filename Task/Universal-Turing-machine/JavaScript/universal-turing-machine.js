function tm(d,s,e,i,b,t,... r) {
	document.write(d, '<br>')
	if (i<0||i>=t.length) return
	write('*',s,i,t=t.split(''))
	var p={}; r.forEach(e=>((s,r,w,m,n)=>{p[s+'.'+r]={w,n,m:[0,1,-1][1+'RL'.indexOf(m)]}})(... e.split(/[ .:,]+/)))
	for (var n=1; s!=e; n+=1) {
		with (p[s+'.'+t[i]]) t[i]=w,s=n,i+=m
		if (i==-1) i=0,t.unshift(b)
		else if (i==t.length) t[i]=b
		write(n,s,i,t)
	}
	document.write('<br>')
	function write(n, s, i, t) {
		t = t.join('')
		t = t.substring(0,i) + '<u>' + t.charAt(i) + '</u>' + t.substr(i+1)
		document.write(('  '+n).slice(-3).replace(/ /g,'&nbsp;'), ': ', s, ' [', t.replace(b,'&nbsp;','g'), ']', '<br>')
	}
}

tm( 'Unary incrementer',
//	 s    e   i   b    t
	'a', 'h', 0, 'B', '111',
//	 s.r: w, m, n
	'a.1: 1, L, a',
	'a.B: 1, S, h'
)
	
tm( 'Unary adder',
	1, 0, 0, '0', '1110111',
	'1.1: 0, R, 2', // write 0 rigth goto 2
	'2.0: 0, S, 0', // if (0) halt
	'2.1: 0, R, 3', // write 0 rigth goto 3
	'3.1: 1, R, 3', // while (1) rigth
	'3.0: 1, S, 0', // write 1 halt
)
		
tm( 'Three-state busy beaver',
	1, 0, 0, '0', '0',
	'1.0: 1, R, 2',
	'1.1: 1, R, 0',
	'2.0: 0, R, 3',
	'2.1: 1, R, 2',
	'3.0: 1, L, 3',
	'3.1: 1, L, 1'
)
