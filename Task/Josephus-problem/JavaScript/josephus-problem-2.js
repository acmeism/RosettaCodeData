function Josephus(n, k, s) {
	s = s | 1
	for (var ps=[], i=n; i--; ) ps[i]=i
	for (var ks=[], i=--k; ps.length>s; i=(i+k)%ps.length) ks.push(ps.splice(i, 1))
	document.write((arguments.callee+'').split(/\s|\(/)[1], '(', [].slice.call(arguments, 0), ') -> ', ps, ' / ', ks.length<45?ks:ks.slice(0,45)+',...' , '<br>')
	return [ps, ks]
}
